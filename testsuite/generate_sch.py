"""
*********************************************************************************************************
:copyright (c) BuildingSync®, Copyright (c) 2015-2021, Alliance for Sustainable Energy, LLC,
and other contributors.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

(1) Redistributions of source code must retain the above copyright notice, this list of conditions
and the following disclaimer.

(2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions
and the following disclaimer in the documentation and/or other materials provided with the distribution.

(3) Neither the name of the copyright holder nor the names of any contributors may be used to endorse
or promote products derived from this software without specific prior written permission from the
respective party.

(4) Other than as required in clauses (1) and (2), distributions in any form of modifications or other
derivative works may not use the "BuildingSync" trademark or any other confusingly similar designation
without specific prior written permission from Alliance for Sustainable Energy, LLC.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) AND ANY CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER(S), ANY
CONTRIBUTORS, THE UNITED STATES GOVERNMENT, OR THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF
THEIR EMPLOYEES, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*********************************************************************************************************
"""

import copy
import csv
import os
import re

from lxml import etree

from testsuite.constants import SCH_NS, SCH_NSMAP, BSYNC_NSMAP


# global variable for tracking visited nodes in the exemplary xml
# see functions check_xpath and reset_rule_visits
_NODE_VISITS = {}


def qname(name):
    """
    Prefixes the name with schematron namespace
    :param name: str
    :returns: str
    """
    return etree.QName(SCH_NS, name)


def to_id(name):
    return name.lower().replace(' ', '_')


def check_xpath(tree, xpath):
    """
    Checks the xpath against the given tree

    :param tree: lxml.etree.Element, tree to test
    :param xpath: str, xpath to test (assumed to use BuildingSync namespace)
    :returns: matches_any_nodes (bool), num_matched_visited (int), num_matched_unvisited (int)
    """
    global _NODE_VISITS
    visited = 0
    unvisited = 0
    for node in tree.xpath(xpath, namespaces=BSYNC_NSMAP):
        if node in _NODE_VISITS:
            visited += 1
        else:
            unvisited += 1
            _NODE_VISITS[node] = True

    return visited + unvisited > 0, visited, unvisited


def reset_rule_visits():
    """
    Resets the global tracking of visited nodes from rule contexts
    Should be called at the start of each new pattern
    """
    global _NODE_VISITS
    _NODE_VISITS = {}


def get_rule_warnings(tree, xpath):
    """
    Returns any warnings about the xpath to the console. e.g. If a path matches no nodes in the tree

    :param tree: lxml.etree.Element, tree to test
    :param xpath: str, xpath to test
    """
    warnings = []
    try:
        matched, num_visited, num_unvisited = check_xpath(tree, xpath)
        if not matched and xpath != "/":
            warnings.append(f'WARNING: found no matches with exemplary xml for rule\n    context: {xpath}')
        if num_visited > 0:
            warnings.append(f'WARNING: rule matches nodes that have already been visited in this pattern: matched and already visited: {num_visited}; matched and unvisited: {num_unvisited}\n    context: {xpath}')
    except Exception as e:
        warnings.append(f'WARNING: failed to check rule: {e}\n    context: {xpath}')
    return warnings


def add_assert_description(assert_elem, description):
    """
    Adds the description data to the assert element. Note that any elements in the
    description string are assumed to be schematron elements (rather than BuildingSync
    or some other namespace)

    :param assert_elem: etree.Element, the assert element who's content is to be updated
    :param description: str, the description string. any elements will be parsed from the string
    """
    # find any elements in the description, instantiate them as etree elements
    # and record their character span in the original text
    p = re.compile("<.*?/>")
    inserted_elements = []
    matches = p.finditer(description)
    for match in matches:
        elem_text = match.group()
        some_elem = etree.fromstring(elem_text)
        # turn it into a namespaced element and append it
        inserted_elem = etree.SubElement(assert_elem, qname(some_elem.tag), **{k: v for (k, v) in some_elem.items()})
        inserted_elements.append({
            'element': inserted_elem,
            'text_span': match.span()
        })

    if not inserted_elements:
        assert_elem.text = description
    else:
        # add text up to first inserted element
        prev_span = inserted_elements[0]['text_span']
        assert_elem.text = description[:prev_span[0]]

        # for each remaining element, add the text between the end of the previous
        # element and beginning of the current element
        prev_elem = inserted_elements[0]['element']
        for inserted_elem in inserted_elements[1:]:
            current_span = inserted_elem['text_span']
            prev_elem.tail = description[prev_span[1]:current_span[0]]
            prev_span = current_span
            prev_elem = inserted_elem['element']

        # add remaining text after last element
        prev_elem.tail = description[prev_span[1]:]


def make_pattern_for_testing_contexts(pattern):
    """
    Given a pattern, it returns a new pattern which makes assertions that every
    rule context in the original pattern exists.

    :param pattern: dict, schematron pattern in dictionary format; Note that rules are expected to have key 'generate_context_test' with a bool value to indicate if a test should be generated for its context
    :returns: dict, a new schematron pattern in dictionary format
    """
    collected_contexts = {rule['context']: True for rule in pattern['rules'] if rule['generate_context_test']}
    if len(collected_contexts) == 0:
        return None

    # create a "prerequisites" pattern to store our structure assertions
    title = f'Document Structure Prerequisites {pattern["title"]}'
    prereq_pattern = {
        'title': title,
        'id': to_id(title),
        'see': '',
        'rules': [],
    }

    prereq_pattern['rules'] = [
        {
            'variables': [],
            'context': '/',
            'asserts': [{
                'test': assertion,
                'description': '',
                'role': 'ERROR',
            } for assertion in collected_contexts]
        }
    ]

    return prereq_pattern


def generate_tests_for_rule_contexts(orig_sch_dict):
    """
    Generates a new pattern for each existing pattern, where each new pattern asserts
    the contexts used in the existing pattern rules exist in the document.

    This is used to get around the fact that Schematron does not consider a non-matched
    rule to be a failure, while we want them to be.

    :param orig_sch_dict: dict, schematron in dictionary format
    :returns: dict, a new schematron dictionary with new patterns added
    """
    new_sch_dict = copy.deepcopy(orig_sch_dict)
    for phase_idx, phase in enumerate(orig_sch_dict['phases']):
        num_inserted_patterns = 0
        for orig_pattern_idx, pattern in enumerate(phase['patterns']):
            prereq_pattern = make_pattern_for_testing_contexts(pattern)
            if prereq_pattern is None:
                continue

            # insert the prerequisite pattern right before the original one
            prereq_insert_idx = (orig_pattern_idx + num_inserted_patterns)
            new_sch_dict['phases'][phase_idx]['patterns'].insert(prereq_insert_idx, prereq_pattern)
            num_inserted_patterns += 1

    return new_sch_dict


def generate_sch(csv_file, output_file=None, exemplary_xml_file=None, dry_run=False, schema_version=''):
    """
    Generates a schematron file from a csv file

    :param csv_file: str, path to csv for schematron generation
    :param output_file: str | None, optional, location to save the result. If None, it
        will be saved with the same name as the CSV file
    :param exemplary_xml_file: str | None, path to an xml file which should pass the schematron validation
    :param dry_run: bool, optional, if True it will not save the result to a file
    :param schema_version: str, optional, used for sch:schema@schemaVersion
    :return: bool, True if the generated result is different than the existing
        output file file. It will always return true when no output file file existed before
    """
    with open(csv_file, encoding='utf-8-sig') as f:
        rows = [{k: v for k, v in row.items()}
                for row in csv.DictReader(f, skipinitialspace=True)]

    # convert flat rows to hierarchical (nested) representation
    sch_dict = {
        'phases': []
    }
    current_phase = None
    current_pattern = None
    current_rule = None
    for i, row in enumerate(rows):
        # handle new phase
        if row['phase title']:
            new_phase = {
                'title': row['phase title'],
                'see': row['phase see'],
                'id': to_id(row['phase title']),
                'patterns': []
            }
            if not row['pattern title']:
                raise Exception(f'New phase row is missing new pattern title (row {i + 2})')  # +1 b/c 0-based, +1 b/c csv header
            current_phase = new_phase
            sch_dict['phases'].append(current_phase)

        # handle new pattern
        if row['pattern title']:
            new_pattern = {
                'title': row['pattern title'],
                'see': row['pattern see'],
                'id': to_id(row['pattern title']),
                'rules': [],
            }
            if not row['rule context']:
                raise Exception(f'New pattern row is missing new rule context (row {i + 2})')  # +1 b/c 0-based, +1 b/c csv header
            current_pattern = new_pattern
            current_phase['patterns'].append(current_pattern)

        # handle new rule
        if row['rule context']:
            generate_context_test = row.get('generate context test', '').lower().strip()
            if generate_context_test not in ['true', 'false']:
                raise Exception(f'Missing required value of "true" or "false" for column "generate context test" in row {i + 2}')
            generate_context_test = generate_context_test == 'true'

            new_rule = {
                'title': row['rule title'],
                'context': row['rule context'],
                'asserts': [],
                'variables': [],
                'generate_context_test': generate_context_test
            }

            current_rule = new_rule
            current_pattern['rules'].append(current_rule)

        if row.get('let name'):
            new_variable = {
                'name': row['let name'],
                'value': row['let value'],
            }
            current_rule['variables'].append(new_variable)

        # every row must include an assert statement
        if row['assert test']:
            role = row['assert severity']
            if not role:
                role = 'ERROR'

            new_assert = {
                'test': row['assert test'],
                'description': row['assert description'],
                'role': role
            }
            current_rule['asserts'].append(new_assert)

    sch_dict = generate_tests_for_rule_contexts(sch_dict)

    # convert dict to schematron document, validating rule contexts as we go
    exemplary_xml = None
    if exemplary_xml_file is not None:
        exemplary_xml = etree.parse(exemplary_xml_file)
    root = etree.Element(qname('schema'), nsmap=SCH_NSMAP, schemaVersion=schema_version, queryBinding='xslt1')
    etree.SubElement(root, qname('ns'), prefix="auc", uri="http://buildingsync.net/schemas/bedes-auc/2019")

    # used to add patterns at the end of the root element after everything's finished
    collected_patterns = []

    for phase in sch_dict['phases']:
        phase_elem = etree.SubElement(root, qname('phase'), id=phase['id'], see=phase['see'])
        for pattern in phase['patterns']:
            reset_rule_visits()
            etree.SubElement(phase_elem, qname('active'), pattern=pattern['id'])

            pattern_elem = etree.Element(qname('pattern'), see=pattern['see'], id=pattern['id'])
            etree.SubElement(pattern_elem, qname('title')).text = pattern['title']
            collected_patterns.append(pattern_elem)

            for rule in pattern['rules']:
                if exemplary_xml is not None:
                    for warning in get_rule_warnings(exemplary_xml, rule['context']):
                        print(warning)

                rule_elem = etree.SubElement(pattern_elem, qname('rule'), context=rule['context'])

                for variable in rule['variables']:
                    etree.SubElement(rule_elem, qname('let'), name=variable['name'], value=variable['value'])

                for assert_ in rule['asserts']:
                    assert_elem = etree.SubElement(rule_elem, qname('assert'), test=assert_['test'], role=assert_['role'])
                    description = assert_['description']
                    if not description:
                        description = assert_['test']
                    add_assert_description(assert_elem, description)

    for pattern in collected_patterns:
        root.append(pattern)

    sch_bytes = etree.tostring(root, doctype='<?xml version="1.0" encoding="UTF-8"?>', pretty_print=True)
    if output_file is None:
        output_file = f'{os.path.splitext(csv_file)[0]}.sch'

    if os.path.isfile(output_file):
        with open(output_file, 'rb') as f:
            if sch_bytes != f.read():
                file_maybe_updated = True
            else:
                file_maybe_updated = False
    else:
        file_maybe_updated = True

    if not dry_run:
        with open(output_file, 'wb') as f:
            f.write(sch_bytes)

    return file_maybe_updated
