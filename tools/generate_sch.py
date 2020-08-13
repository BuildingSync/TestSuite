
import csv
import os
import sys
from pprint import pprint

from lxml import etree

from constants import SCH_NS, SCH_NSMAP, BSYNC_NSMAP


# global variable for tracking visited nodes in the golden xml
# see functions check_xpath and reset_rule_visits
_NODE_VISITS = {}

def qname(name):
    """
    Prefixes the name with schematron namespace
    :param name: str
    :returns: str
    """
    return etree.QName(SCH_NS, name)

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
            warnings.append(f'WARNING: found no matches with golden xml for rule\n    context: {xpath}')
        if num_visited > 0:
            warnings.append(f'WARNING: rule matches nodes that have already been visited in this pattern: matched and already visited: {num_visited}; matched and unvisited: {num_unvisited}\n    context: {xpath}')
    except Exception as e:
        warnings.append(f'WARNING: failed to check rule: {e}\n    context: {xpath}')
    return warnings

def generate_sch(csv_file, golden_xml_file):
    """
    Generates a schematron file from a csv file

    :param csv_file: str, path to csv for schematron generation
    :param golden_xml_file: str | None, path to an xml file which should pass the schematron validation
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
                'id': row['phase title'].lower().replace(' ', '_'),
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
                'id': row['pattern title'].lower().replace(' ', '_'),
                'rules': [],
            }
            if not row['rule context']:
                raise Exception(f'New pattern row is missing new rule context (row {i + 2})')  # +1 b/c 0-based, +1 b/c csv header
            current_pattern = new_pattern
            current_phase['patterns'].append(current_pattern)

        # handle new rule
        if row['rule context']:
            new_rule = {
                'title': row['rule title'],
                'context': row['rule context'],
                'asserts': []
            }
            if not row['assert test']:
                raise Exception(f'New rule row is missing new assert test (row {i + 2})')  # +1 b/c 0-based, +1 b/c csv header
            current_rule = new_rule
            current_pattern['rules'].append(current_rule)

        # every row must include an assert statement
        if not row['assert test']:
            raise Exception(f'Row is missing new assert test (row {i + 2})')  # +1 b/c 0-based, +1 b/c csv header

        new_assert = {
            'test': row['assert test'],
            'description': row['assert description'],
            'role': row['assert severity']
        }
        current_rule['asserts'].append(new_assert)
    
    # convert dict to schematron document, validating rule contexts as we go
    golden_xml = None
    if golden_xml_file is not None:
        golden_xml = etree.parse(golden_xml_file)
    root = etree.Element(qname('schema'), nsmap=SCH_NSMAP)
    etree.SubElement(root, qname('ns'), prefix="auc", uri="http://buildingsync.net/schemas/bedes-auc/2019")

    # used to add patterns at the end of the root element after everything's finished
    collected_patterns = []

    for phase in sch_dict['phases']:
        phase_elem = etree.SubElement(root, qname('phase'), id=phase['id'], see=phase['see'])
        for pattern in phase['patterns']:
            reset_rule_visits()
            active_elem = etree.SubElement(phase_elem, qname('active'), pattern=pattern['id'])

            pattern_elem = etree.Element(qname('pattern'), see=pattern['see'], id=pattern['id'])
            etree.SubElement(pattern_elem, qname('title')).text = pattern['title']
            collected_patterns.append(pattern_elem)

            for rule in pattern['rules']:
                if golden_xml is not None:
                    for warning in get_rule_warnings(golden_xml, rule['context']):
                        print(warning)

                rule_elem = etree.SubElement(pattern_elem, qname('rule'), context=rule['context'])

                for assert_ in rule['asserts']:
                    assert_elem = etree.SubElement(rule_elem, qname('assert'), test=assert_['test'], role=assert_['role'])
                    description = assert_['description']
                    if not description:
                        description = assert_['test']
                    assert_elem.text = description
    
    for pattern in collected_patterns:
        root.append(pattern)

    sch_str = etree.tostring(root, pretty_print=True, xml_declaration=True).decode()
    with open(f'{os.path.splitext(csv_file)[0]}.sch', 'w') as f:
        f.write(sch_str)


if __name__ == '__main__':
    sch_file = sys.argv[1]
    if len(sys.argv) == 3:
        golden_file = sys.argv[2]
    else:
        golden_file = None
        print('INFO: No golden xml file provided - will not be able to check for potential unfired rule contexts')
    generate_sch(sch_file, golden_file)
