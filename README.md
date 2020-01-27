# Overview

This repository hosts test files and examples for the BuildingSync schema.  As newer versions of the schema are released, this repository will be updated to include relevant changes.  Currently, all example files are based on [schema2.0.0-pr2](https://github.com/BuildingSync/schema/releases/tag/v2.0-pr2).

## System Requirements 

In order to run the tests you must have a stable version of the following:
* `OpenStudio>2.0` 
* `Ruby v2.2.4` via an `rbenv` environment 
* `Bundler v1.17.2`

## Setup
Place a file called `openstudio.rb` into the the directory of your `Ruby2.2.4` installation `/foo/bar/.rbenv/versions/2.2.4/lib/ruby/2.2.4`

The `openstudio.rb` file should contain one line referencing the location of the Ruby folder of your OpenStudio installation:
```
require '/Applications/OpenStudio-2.9.1/Ruby/openstudio.rb'
```
___Note - your version of OpenStudio may be different___

Now, 
```
bundle install
```

## Level Definitions
The formal definitions for the levels are defined using Schematron files, which are located at `tests/[schema_version]/[Level_XXX]/BuildingSync_schematron_LXXX.xml`.  The levels are in alignment with the ASHRAE Standard 211 levels as defined below:

| Level | Alignment to Std 211 | Std 211 Section |
|-----------|----------------------|-----------------|
| Level 000 | Preliminary Analysis | Section 5.2.3 |
| Level 100 | Level 1 | Section 6.1 |
| Level 200 | Level 2 | Section 6.2 |
| Level 300 | Level 3 | Section 6.3 |
| Level 400 | Not Applicable | Not Applicable |
| Level 500 | Not Applicable | Not Applicable |

Narrative overviews for the different levels can be found in the [Level Definitions doc](<https://github.com/BuildingSync/TestSuite/blob/master/docs/Level Definitions.md>).

# Running Simulations (Rakefile)

The Rakefile can be used to run the entire BuildingSync -> OpenStudio + Simulate -> BuildingSync workflow.  It makes use of the `tests/tester.rb` script.  The script will look for BSync XML files to simulate in the `tests/[schema_version]/[Level_XXX]/inputs` directory.  There are currently two tasks that can be run:

1. L000_run_sim - Run a Level 000 simulation using the schema_version and file specified
1. L100_run_sim - Run a Level 100 simulation using the schema_version and file specified
    
Tasks can be run as follows from the TestSuite directory:
- Run the L000_Instance1.xml file for the schema2.0.0-pr2 schema version

```
$ bundle exec rake L000_run_sim[schema2.0.0-pr2,L000_Instance1.xml]
```

## Outputs
An outputs directory will be created after running a task `tests/[schema_version]/[Level_XXX]/outputs` for each file instance run through the task runner.  Outputs are .gitignored so as not to clutter up the TestSuite repo.  The output directory  will mimic the traditional OSW structure.


## HVAC System Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|
| PSZ System |  | [L100_Instance1.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_100/inputs/L100_Instance1.xml) |  |
| VAV |  | [L100_Instance2.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_100/inputs/L100_Instance2.xml) |  |
| Shared Boiler |  | TODO |  |
| DOAS & Radiant |  | TODO |  |
| Inferred from OpenStudio Standards | [L000_Instance1.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_000/inputs/L000_Instance1.xml) |  |  |
|  | [L000_Instance2.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_000/inputs/L000_Instance1.xml) |  |  |

## Lighting System Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|

## Premise Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|
