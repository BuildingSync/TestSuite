# testsuite

[![PyPI version](https://badge.fury.io/py/testsuite.svg)](https://badge.fury.io/py/testsuite)

![example workflow](https://github.com/buildingsync/testsuite/actions/workflows/ci.yml/badge.svg?branch=develop)

A tool for writing and validating BuildingSync use cases as Schematron files.
See the [BuildingSync use-cases](https://github.com/BuildingSync/use-cases) repository for current Schematron and example files for particular use cases.

## Command line validation
### Setup
#### Install from pypi
```bash
pip install testsuite
```
#### Install from source
[Poetry](https://python-poetry.org/) is required to install testsuite.
```bash
# Copy repo
git clone https://github.com/BuildingSync/TestSuite.git

# install the package
cd TestSuite
poetry install

# Test that it works, you should see a message describing the usage
poetry run testsuite
```

## Usage
### Python
```python
from testsuite.validate_sch import validate_schematron

# run basic validation
# returns an array of testsuite.validate_sch.Failures
failures = validate_schematron('my_schematron.sch', 'my_xml.xml')

# save the svrl result file
failures = validate_schematron('my_schematron.sch', 'my_xml.xml', result_path='validation_result.svrl')

# run a specific phase in schematron
failures = validate_schematron('my_schematron.sch', 'my_xml.xml', phase='MyPhaseID')

# report unfired rules as errors
failures = validate_schematron('my_schematron.sch', 'my_xml.xml', strict_context=True)
```

### CLI
```bash
testsuite validate my_schematron.sch my_xml.xml

# see all options
testsuite validate --help
```

## Development
### Generate Schematron
First create a CSV file that meets the required structure:
```
phase title,phase see,pattern title,pattern see,rule title,rule context,assert test,assert description,assert severity,notes
```
See the CSV files in this repo for examples.

Hierarchy is implied by the lack of text in a column. If no phase data is added to a row, it's considered to be the same phase as the row above. If no pattern data is present, it's assumed to be the same pattern as above. If no rule context is given, it's assumed to be the same as the one above.

The generator expects a "exemplary" xml file which should pass the validation. This is used to make sure all rules are applied (schematron will skip rules if the rule context doesn't match or if it only matches nodes that have already been matched within that pattern). If no exemplary file is provided no rule context checks will be made.
```bash
poetry run testsuite generate path_to_csv [path_to_exemplary_xml]
```

### Testing
```bash
poetry run tox -e python
```
