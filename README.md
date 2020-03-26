# Overview

This repository hosts test files and examples for the BuildingSync schema.  As newer versions of the schema are released, this repository will be updated to include relevant changes.  Currently, all example files are based on [schema2.0.0](https://github.com/BuildingSync/schema/releases/tag/v2.0).

## System Requirements 

In order to run the OpenStudio simulation tests you must have a stable version of the following:
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

Due to dependency issues, there are currently two Gemfiles available in the repo.  Refer to the linked sections for specifics on how to use.
1. `Gemfile` - Use this for running Rake tasks for [running simulation tests](#running-simulation-tests)
1. `Gemfile-sch` - Use this for running Rake tasks for [schematron tests](#schematron-tests)

__Note - there is no need to `rm -rf .bundle/` when switching between the above two scenarios.  Just run the below commands and then proceed as described in the linked sections__
```
$ bundle install --gemfile Gemfile --path .bundle/install
$ bundle install --gemfile Gemfile-sch --path .bundle/install
```

## Modeling Level of Detail Definitions
The Modeling Level of Detail (MLOD) is similar in concept to the [Model View Definitions (MVD)](https://technical.buildingsmart.org/standards/mvd/) defined by IFC.  MLODs define a subset of the overall BuildingSync schema necessary for a specific use case or workflow.  The two primary use cases for defining levels are to:
1. Ensure alignment with different portions of ASHRAE Standard 211 (Use Case = Audit)
1. Enable BuilingSync XML files to be used with the [BuildingSync gem](https://github.com/BuildingSync/BuildingSync-gem) and run through the OpenStudio simulation workflow. (Use Case = OpenStudio_Simulation)

The formal definitions for the levels are defined using Schematron files, which are located in `spec/use_cases/[schema_version]/[Level_XXX]_[Use_Case].sch`. Level definitions are in alignment with the ASHRAE Standard 211 levels as defined below:

| MLOD | Use Case | Alignment to Std 211 | Std 211 Section |
|-----------|----------------------|-----------------|---|
| Level 000 | Audit | Preliminary Analysis | Section 5.2.3 |
| Level 100 | Audit | Level 1 | Section 6.1 |
| Level 200 | Audit | Level 2 | Section 6.2 |
| Level 300 | Audit | Level 3 | Section 6.3 |
| Level 400 | Audit | Not Applicable | Not Applicable |
| Level 500 | Audit | Not Applicable | Not Applicable |

__Note - MLOD definitions for use with the OpenStudio Simulation use case are significantly reduced compared to requirements for the 211 Standard, since only certain elements are used when generating a model for simulation.  For example, to define a Level_000 Simulation file, an auc:ScenarioType/auc:Benchmark is not required, nor are things like auc:Contacts, however we do rely on fields like auc:Building/auc:YearOfConstruction to drive the vintage of code standard used.  More specifics to follow.__

The `lib` directory provides a library of general purpose Schematron functions used  within the individual Schematron documents.  These functions are designed to be used by others with use cases outside of the Levels defined above.  Narrative overviews for the different levels can be found in `docs`.

# Rakefile
Rake tasks are currently used for two purposes:
1. Tests
1. Running Simulations

## Schematron Tests
RSpec is used for running tests.  The tests are written around the following:
1. Testing individual Schematron functions within `lib/` are working correctly. In Progress.
1. Testing that Schematron is working against Level Definition files.  In Progress.

```
$ bundle install --gemfile Gemfile-sch --path .bundle/install # if not previously run
$ BUNDLE_GEMFILE=Gemfile-sch bundle exec rake spec
```

More information on developing Schematron functions (and the required tests!) can be found in the `docs/Contributions and Schematron.md` document.

## Running Simulation Tests

Tests are also written for OpenStudio Simulation files.  Examples for how to use the BuildingSync-gem and the Translator class to run OpenStudio simulations using a BuildingSync XML file can be found in the `spec/simulations/**_spec.rb` files.  Since running all of the files through a simulation can be computationally expensive, tests are separated into two scenarios:
1. Translation of BuildingSync XML file into the OSM / OSW.
1. Simulation of the OSW.

By default, all of the files are removed after the translation/simulation occurs.  This can be overriden by passing the `REMOVE_FILES=false` environment variable.  Tests can be run as follows:

__Test that simulation files are translated (files will be removed after test)__
```
$ BUNDLE_GEMFILE=Gemfile bundle exec rake translate
```

__Test that simulation files can be simulated (files will remain after test)__
```
$ BUNDLE_GEMFILE=Gemfile bundle exec rake simulate REMOVE_FILES=false
```

### Outputs
Output directories will be created after running either the translation or simulation tests and are located in `spec/simulations/[schema-version]/[sim-file]/`.

# Examples
## HVAC System Examples

Where the System Type specified below does not exactly match the enumeration in the BSync XML file, check the mapping defined by [map_primary_hvac_system_type_to_cbecs_system_type](https://github.com/BuildingSync/BuildingSync-gem/blob/bb52655ebb8efeca44249277d3fb67ac60b4e610/lib/buildingsync/model_articulation/hvac_system.rb#L121-L143).  Additionally, see the [examples/HVACSystems](https://github.com/BuildingSync/TestSuite/tree/L100_Schematron/examples/HVACSystems) directory for a tutorial and example files.

| File                                                                                                                                                                      | Specified For  | System Type                                       | Translate Tested | Simulate Tested | [MLOD](#modeling-level-of-detail-definitions) | Use Case              | Validates Against              | Description                                                                                                                                    |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------------------------------------------------|------------------|-----------------|------|-----------------------|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| [L000_OpenStudio_Simulation_01.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_01.xml) | Building       | VAV with reheat                                   | TRUE             | TRUE            | L000 | OpenStudio_Simulation | L000_OpenStudio_Simulation.sch | No system-type actually declared.  System inferred from OpenStudio Standards based on Building's OccupancyClassification and Gross floor area. |
| [L000_OpenStudio_Simulation_02.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_02.xml) | Building       | PSZ-AC with gas reheat                            | TRUE             | TRUE            | L000 | OpenStudio_Simulation | L000_OpenStudio_Simulation.sch | No system-type actually declared.  System inferred from OpenStudio Standards based on Building's OccupancyClassification and Gross floor area. |
| [L100_OpenStudio_Simulation_01.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L100_OpenStudio_Simulation_01.xml) | Section-Retail | PSZ-AC with gas reheat                            | TRUE             | TRUE            | L100 | OpenStudio_Simulation | None                           | Packaged Rooftop Air Conditioner is mapped to PSZ-AC with gas reheat.                                                                          |
| [L100_OpenStudio_Simulation_01.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L100_OpenStudio_Simulation_01.xml) | Section-Office | PVAV with PFP boxes                               | TRUE             | TRUE            | L100 | OpenStudio_Simulation | None                           | Packaged Rooftop VAV with Electric Reheat is mapped as PVAV with PFP boxes                                                                     |
| [PSZ-AC-CDM-001.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/examples/HVACSystems/PSZ-AC-CDM-001.xml)                                              | Section        | PSZ-AC                                            | FALSE            | FALSE           | L200 | Audit                 | None                           | Example of constructing more complex, L200 system.                                                                                             |
| [PSZ-HP-CDM-001.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/examples/HVACSystems/PSZ-HP-CDM-001.xml)                                              | Section        | PSZ-HP                                            | FALSE            | FALSE           | L200 | Audit                 | None                           | Example of constructing more complex, L200 system.                                                                                             |


## Lighting System Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|

## Premise Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|

# Contributing
See [Contributions and Schematron](docs/Contributions%20and%20Schematron.md)