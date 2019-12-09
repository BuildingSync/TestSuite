# Overview

This repository hosts test files and examples for the BuildingSync schema.  As newer versions of the schema are released, this repository will be updated to include relevant changes.  Currently, all example files are based on [schema2.0.0-pr2](https://github.com/BuildingSync/schema/releases/tag/v2.0-pr2).


## HVAC System Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|
| PSZ System |  | [L100_Instance1.xml](./tests/schema2.0.0-pr2/Level_100/inputs/L100_Instance1.xml) |  |
| VAV |  | [L100_Instance2.xml](./tests/schema2.0.0-pr2/Level_100/inputs/L100_Instance2.xml) |  |
| Shared Boiler |  | TODO |  |
| DOAS & Radiant |  | TODO |  |
| Inferred from OpenStudio Standards | [L000_Instance1.xml](./tests/schema2.0.0-pr2/Level_000/inputs/L000_Instance1.xml) |  |  |
|  | [L000_Instance2.xml](./tests/schema2.0.0-pr2/Level_000/inputs/L000_Instance2.xml) |  |  |

## Lighting System Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|

## Premise Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|




# Tests

The tests folder contains similar code used to generate schematron XML documents, based on the requirements of the different levels.

# Usage

TODO: Run test for different levels
```
bundle exec rake L100_test
```

