#!/usr/bin/env python3
import argparse
import os
import sys

from testsuite.validate_sch import validate_schematron, print_failure
from testsuite.generate_sch import generate_sch
from testsuite.clean_xml import clean_files


def validate_schematrons(args):
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
            print_failure(doc, f, colored=args.color, verbose=args.verbose)

    if num_errors > 0:
        sys.exit(1)
    sys.exit(0)


def generate_schematron(args):
    if args.exemplary_xml is None:
        print('INFO: No exemplary xml file provided - will not be able to check for potential unfired rule contexts')
    generate_sch(args.source_csv, args.output, args.exemplary_xml)


def generate_all_schematron(args):
    """
    Runs generator for all CSVs it can find under schematron/ and prints out the
    names of CSVs that resulted in new schematron files.
    """
    base_dir = 'schematron/'
    updated_files = []
    for root, _, files in os.walk(base_dir):
        for name in files:
            if not name.endswith('.csv'):
                continue
            filename = os.path.join(root, name)
            updated = generate_sch(filename, dry_run=args.dry_run)
            if updated:
                updated_files.append(filename)

    for file_ in updated_files:
        print(file_)

    if args.dry_run and len(updated_files) > 0:
        print('Expected no files to be modified after generating Schematron. Update the Schematron by running `testsuite generate_all`')
        sys.exit(1)
    sys.exit(0)


def _clean_files(args):
    for filename in args.filenames:
        clean_files(filename)


def clean_all_files(args):
    """
    Cleans all *.sch and *.xml files in the schematron directory.  Cleaning consists of:
    - Removing blank lines
    - Two space indentation
    - Serializing with doctype = '<?xml version="1.0" encoding="UTF-8"?>
    """
    base_dir = 'schematron/'
    updated_files = []
    for root, _, files in os.walk(base_dir):
        for name in files:
            if not name.endswith('.xml') and not name.endswith('.sch'):
                continue
            filename = os.path.join(root, name)
            updated = clean_files(filename)
            if updated:
                updated_files.append(filename)

    for file_ in updated_files:
        print(file_)

    sys.exit(0)


def main():
    # Construct Parsers
    parser = argparse.ArgumentParser(description='Tool for validating and generating Schematron documents')
    subparsers = parser.add_subparsers()

    # Validation command
    parser_validate = subparsers.add_parser('validate', description='Command for validation XML files against Schematron')
    parser_validate.add_argument(
        'schematron',
        metavar='sch',
        type=str,
        help='schematron to run'
    )
    parser_validate.add_argument(
        'documents',
        metavar='doc',
        type=str,
        nargs='+',
        help='one or more documents to test'
    )
    parser_validate.add_argument(
        '-c',
        '--color',
        action='store_true',
        help='print the failures using colors'
    )
    parser_validate.add_argument(
        '-o',
        '--output',
        type=str,
        default=None,
        help='path to file to save validation result'
    )
    parser_validate.add_argument(
        '-p',
        '--phase',
        type=str,
        default=None,
        help='id of phase to run'
    )
    parser_validate.add_argument(
        '-s',
        '--strict',
        action='store_true',
        help='reports, as errors, rules that were not applied to the document (ie context did not match)'
    )
    parser_validate.add_argument(
        '-v',
        '--verbose',
        action='store_true',
        help='increase verbosity of report'
    )
    parser_validate.set_defaults(func=validate_schematrons)

    # Generator command
    parser_generate = subparsers.add_parser('generate', description='Command for generating Schematron from CSV files')
    parser_generate.add_argument(
        'source_csv',
        metavar='csv',
        type=str,
        help='Source CSV to generate schematron from',
    )
    parser_generate.add_argument(
        'exemplary_xml',
        nargs='?',
        type=str,
        default=None,
        help='XML file which should pass the schematron\'s validation'
    )
    parser_generate.add_argument(
        '-o',
        '--output',
        type=str,
        default=None,
        help='path to file to save generated schematron'
    )
    parser_generate.set_defaults(func=generate_schematron)

    # Generate all command
    parser_generate = subparsers.add_parser('generate_all', description='Command for generating Schematron files for all CSV files under schematron/')
    parser_generate.add_argument(
        '-d',
        '--dry-run',
        action='store_true',
        help='Does not modify files, but list files and exits with non-zero if files would have been modified'
    )
    parser_generate.set_defaults(func=generate_all_schematron)

    # Clean command
    parser_clean_files = subparsers.add_parser('clean', description='Command for formatting one ore more *.xml or *.sch files')
    parser_clean_files.add_argument(
        'filenames',
        metavar='filenames',
        type=str,
        help='File(s) to clean',
        nargs='+'
    )
    parser_clean_files.set_defaults(func=_clean_files)

    # Clean all command
    parser_clean_all_files = subparsers.add_parser('clean_all', description='Command for formatting all *.xml and *.sch files')
    parser_clean_all_files.set_defaults(func=clean_all_files)

    # command with no sub-commands should just print help
    parser.set_defaults(func=lambda _: parser.print_help())

    args = parser.parse_args()
    args.func(args)
