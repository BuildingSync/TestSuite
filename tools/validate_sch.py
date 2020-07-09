import argparse
from collections import namedtuple
import os
import sys

from lxml import etree, isoschematron

from .constants import SVRL_NSMAP

Failure = namedtuple('Failure', ['line', 'element', 'message', 'role'])

def validate_schematron(schematron, document, result_path=None, phase=None):
    """
    Runs schematron on the given document and returns an array of failures

    :param schematron: str, path to sch file or string containing schematron xml
    :param document: str, path to xml file to test or string containing document xml
    :param result_path: str, path to file to save the svrl result
    :returns: Failure[], list of failures
    """
    try:
        schematron_tree = etree.fromstring(schematron)
    except etree.XMLSyntaxError:
        schematron_tree = etree.parse(schematron)
        
    schematron = isoschematron.Schematron(schematron_tree, store_report=True, phase=phase)

    try:
        document_tree = etree.fromstring(document)
    except etree.XMLSyntaxError:
        document_tree = etree.parse(document)

    schematron.validate(document_tree)
    strout = etree.tostring(schematron.validation_report, pretty_print=True)
    if result_path is not None:
        with open(result_path, 'wb') as f:
            f.write(strout)

    failed_asserts = schematron.validation_report.xpath(
        '/svrl:schematron-output/svrl:failed-assert',
        namespaces=SVRL_NSMAP)

    failures = []
    for failed_assert in failed_asserts:
        # location stores an xpath to the element which failed validation
        location = failed_assert.get('location')
        failed_element = document_tree.xpath(location)[0]
        tag = failed_element.tag.replace("{http://buildingsync.net/schemas/bedes-auc/2019}", "auc:")
        error_message = failed_assert[0].text
        failures.append(Failure(
            line=failed_element.sourceline,
            element=tag,
            message=error_message,
            role=failed_assert.get('role', 'ERROR')
        ))
    return failures


def print_failure(filename, failure, colored=False):
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
    message = f'[{failure.role}] {filename}:{failure.line}:{failure.element}: {failure.message}'
    if colored:
        message = color_string(message, failure.role)
    print(message)
