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

from collections import namedtuple

from lxml import etree, isoschematron

from .constants import SVRL_NSMAP, SCH_NSMAP, BSYNC_NSMAP

Failure = namedtuple('Failure', ['line', 'element', 'message', 'role', 'location', 'test'])


def _get_unfired_rules(schematron, phase):
    """
    Returns rule contexts that were not fired after running the schematron

    :param schematron: instance of lxml's schematron
    :param phase: str | None, name of specific phase run
    """
    # get expected rules
    schematron_tree = schematron.schematron
    if schematron_tree is None:
        raise Exception('Schematron is missing schematron attribute. Was schematron created with `store_schematron=True`?')

    if phase is None:
        # get all rules in the schematron
        rules = schematron_tree.xpath(
            '//sch:rule',
            namespaces=SCH_NSMAP,
        )
    else:
        # only get the rules that pare part of the specified pattern's active phases
        pattern_ids = schematron_tree.xpath(
            f'//sch:phase[@id = "{phase}"]/sch:active/@pattern',
            namespaces=SCH_NSMAP,
        )

        rules = []
        for pattern_id in pattern_ids:
            rules += schematron_tree.xpath(
                f'//sch:pattern[@id = "{pattern_id}"]/sch:rule',
                namespaces=SCH_NSMAP,
            )

    expected_rules = [rule.get('context') for rule in rules]

    # get fired rules
    result_tree = schematron.validation_report
    if result_tree is None:
        raise Exception('Schematron is missing schematron attribute. Was schematron created with `store_schematron=True`?')

    rules = result_tree.xpath(
        '//svrl:fired-rule',
        namespaces=SVRL_NSMAP,
    )
    fired_rules = [rule.get('context') for rule in rules]

    # find the difference in rule counts between fired and unfired
    rule_counts = {}
    for rule in expected_rules:
        if rule in rule_counts:
            rule_counts[rule] += 1
        else:
            rule_counts[rule] = 1

    for rule in fired_rules:
        rule_counts[rule] -= 1

    # find unfired rules then sort them back into order
    unfired_rules = [rule for rule, count in rule_counts.items() if count > 0]
    unfired_rules = [rule for rule in expected_rules if rule in unfired_rules]

    return unfired_rules


def validate_schematron(schematron, document, result_path=None, phase=None, strict_context=False):
    """
    Runs schematron on the given document and returns an array of failures

    :param schematron: str, path to sch file or string containing schematron xml
    :param document: str | etree._ElementTree, path to xml file to test or string containing document xml or etree
    :param result_path: str, path to file to save the svrl result
    :returns: Failure[], list of failures
    """
    try:
        schematron_tree = etree.parse(schematron)
    except OSError:
        schematron_tree = etree.ElementTree(etree.fromstring(schematron))

    if phase is not None:
        # as an extra precaution, verify there's a phase with the given ID
        phase_elem = schematron_tree.xpath(f'//sch:phase[@id = "{phase}"]', namespaces=SCH_NSMAP)
        if len(phase_elem) == 0:
            raise Exception(f'Found no phase with provided id of "{phase}"')

    schematron = isoschematron.Schematron(
        schematron_tree,
        phase=phase,
        store_report=True,
        store_schematron=True,
    )

    if isinstance(document, str):
        try:
            document_tree = etree.ElementTree(etree.fromstring(document))
        except etree.XMLSyntaxError:
            document_tree = etree.parse(document)
    elif isinstance(document, etree._ElementTree):
        document_tree = document
    else:
        raise Exception(f'Unrecognized type for `document`: {type(document)}. Expected file path, string of xml, or lxml etree instance')

    schematron.validate(document_tree)

    strout = etree.tostring(schematron.validation_report, pretty_print=True)
    if result_path is not None:
        with open(result_path, 'wb') as f:
            f.write(strout)

    failures = []
    if strict_context:
        unfired_rules = _get_unfired_rules(schematron, phase)

        for rule in unfired_rules:
            failures.append(Failure(
                line=0,
                element=None,
                message=f'Rule was NOT used for validation: {rule}',
                role='ERROR',
                location=None,
                test=None
            ))

    failed_asserts = schematron.validation_report.xpath(
        '/svrl:schematron-output/svrl:failed-assert',
        namespaces=SVRL_NSMAP)

    for failed_assert in failed_asserts:
        # location stores an xpath to the element which failed validation
        location = failed_assert.get('location')
        try:
            failed_element = document_tree.xpath(location)[0]
        except IndexError:
            # Somehow, there can rule contexts that are fired, but the resulting
            # svrl location is not a valid xpath for a BuildingSync document.
            # For example, at one point in time, in LL87 `location` is /@version,
            # which is not a valid xpath
            # In these cases, we will just default to the root auc:BuildingSync element
            # If this becomes a more common issue we should reconsider how to locate the failed element
            failed_element = document_tree.xpath('/auc:BuildingSync', namespaces=BSYNC_NSMAP)[0]
        readable_xpath = document_tree.getpath(failed_element)
        tag = failed_element.tag.replace("{http://buildingsync.net/schemas/bedes-auc/2019}", "auc:")
        error_message = failed_assert[0].text
        role = failed_assert.get('role')
        if role is None:
            if '[INFO]' in error_message:
                role = 'INFO'
            elif '[WARNING]' in error_message:
                role = 'WARNING'
            else:
                role = 'ERROR'

        failures.append(Failure(
            line=failed_element.sourceline,
            element=tag,
            message=error_message,
            role=role,
            location=readable_xpath,
            test=failed_assert.get('test'),
        ))
    return failures


def print_failure(filename, failure, colored=False, verbose=False):
    """
    Pretty prints a failure

    :param filename: str, path to file tested
    :param failure: Failure
    :param colored: bool, prints with ansi colors according to failure severity
    """
    def color_string(message, severity):
        RED = '31m'
        YELLOW = '33m'
        BLUE = '34m'
        WHITE = '37m'
        RESET = '0m'
        color_map = {
            'ERROR': RED,
            'WARNING': YELLOW,
            'INFO': BLUE,
        }
        return f'\033[{color_map.get(severity, WHITE)}{message}\033[{RESET}'
    message = f'[{failure.role}] {filename}:{failure.line}: {failure.element}: {failure.message}'
    if verbose:
        message += f'\n    location: {failure.location}\n    test: {failure.test}'
    if colored:
        message = color_string(message, failure.role)
    print(message)
