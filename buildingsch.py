#!/usr/bin/env python3
import argparse
import sys

from tools.validate_sch import validate_schematron, print_failure

parser = argparse.ArgumentParser(description='Run a schematron against one or more documents')
parser.add_argument(
    'schematron',
    metavar='sch',
    type=str,
    help='schematron to run'
)
parser.add_argument(
    'documents',
    metavar='doc',
    type=str,
    nargs='+',
    help='one or more documents to test'
)
parser.add_argument(
    '-c',
    '--color',
    action='store_true',
    help='print the failures using colors'
)
parser.add_argument(
    '-o',
    '--output',
    type=str,
    default=None,
    help='path to file to save validation result'
)
parser.add_argument(
    '-p',
    '--phase',
    type=str,
    default=None,
    help='id of phase to run'
)
parser.add_argument(
    '-s',
    '--strict',
    action='store_true',
    help='reports, as errors, rules that were not applied to the document (ie context did not match)'
)
args = parser.parse_args()
num_errors = 0
for doc in args.documents:
    failures = validate_schematron(
        args.schematron,
        doc,
        result_path=args.output,
        phase=args.phase,
        strict_context=args.strict
    )
    for f in failures:
        if f.role == 'ERROR':
            num_errors += 1
        print_failure(doc, f, colored=args.color)

if num_errors > 0:
    sys.exit(1)
