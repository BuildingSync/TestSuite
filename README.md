# Overview

This repo contains a collection of example BuildingSync files and tools for writing and validating BuildingSync use cases as schematron files.

## Command line validation
### Setup
Python 3 must be installed before continuing. Check your version with `python --version`.
```bash
# Copy repo
git clone https://github.com/BuildingSync/TestSuite.git

# Install dependencies
cd TestSuite
python -m pip install -r requirements.txt

# Test that it works, you should see a message describing the usage
./buildingsch.py
```

## Development
### Generate Schematron
First create a CSV file that meets the required structure:
```
phase title,phase see,pattern title,pattern see,rule title,rule context,assert test,assert description,assert severity,notes
```
To get an example file, run the following
```bash
echo -e \
"phase title,phase see,pattern title,pattern see,rule title,rule context,assert test,assert description,assert severity,notes\n\
Phase A, Section 1.2.3, Pattern A, Section 1.2.3.4, Rule One, /auc:BuildingSync, auc:Facilities,,WARNING,example rule\n\
,,,,,,auc:Facilities/auc:Facility,,," > example_sch.csv
```
Hierarchy is implied by the lack of text in a column. If no phase data is added to a row, it's considered to be the same phase as the row above. If no pattern data is present, it's assumed to be the same pattern as above. If no rule context is given, it's assumed to be the same as the one above.

The generator expects a "golden" xml file which should pass the validation. This is used to make sure all rules are applied (schematron will skip rules if the rule context doesn't match or if it only matches nodes that have already been matched within that pattern). If no golden file is provided no rule context checks will be made.
```bash
python tools/generate_sch.py path_to_csv path_to_golden_xml
```
### Testing
```bash
tox
```

## Ruby tests and validation
We are currently migrating from Ruby to Python, so there is still some remaining Ruby code.
### System Requirements 

In order to run the OpenStudio simulation tests you must have a stable version of the following:
* `OpenStudio>2.0` 
* `Ruby v2.2.4` via an `rbenv` environment 
* `Bundler v1.17.2`

### Setup
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

## Use Cases, Model View Definitions, and Modeling Level of Detail Definitions
As BuildingSync has grown in its ability to represent information about buildings, it is able to define aspects of buildings at varying levels of abstraction.  Additionally, while originally designed to capture energy audit data, data stored in BuildingSync can be used for other purposes as well. Working with data for different purposes and at varying levels of abstraction in a schema is not something new to BuildingSync.  This is a similar problem faced by the building information modeling (BIM) community, where different informational requirements are necessary at different project stages and many different stakeholders are involved in projects. BIM uses the Industry Foundation Classes (IFC) schema for transferring data between applications.  The BuildingSync team utilizes two concepts introduced by the BIM world for refining data expectations needed by different users of the schema: Level of Development (LOD) and Model View Definitions (MVD).

The LOD spec is a comprehensive guide developed by the AIA and BIMForm to help BIM authors describe the depth of their models based on phases of design [reference](https://bimforum.agc.org/lod/).  MVDs are developed by a variety of users in the BIM community to define a subset of the overall schema necessary for a specific use case or workflow [reference](https://www.sciencedirect.com/science/article/abs/pii/S0926580515002319?via%3Dihub).  We utilize these concepts in BuildingSync and define them as follows:

### MVD
A MVD in BuildingSync is intended to provide a narrower focus for which the data stored in a BuildingSync document is intended. It is analogous to the MVD introduced above. The two primary MVDs developed so far are:
    - Audit – To ensure alignment of data contained in the BuildingSync document with portions of the ASHRAE 211 Standard
    - OpenStudio Simulation – To ensure alignment of data contained in the BuildingSync document with requirements necessary to utilize the BuildingSync-gem for automatically generating and simulating an energy model using OpenStudio.
    
### MLOD definitions
The MLOD definitions are intended to provide expectations of informational requirements at differing levels of abstraction.  For example, in BuildingSync, a Building element can be defined to capture high-level information, but narrower levels of abstraction regarding architectural and mechanical space configurations (Section, ThermalZone, or Space elements) can be defined as child elements of the Building to provide more specific information.  This is analogous to the LOD spec introduced above.

### Use case
A use case is a combination of an MVD and a MLOD.  Together, these provide formalized definitions for BuildingSync data expectations.

The formal definitions for each use case is defined using Schematron files, which are located in `spec/use_cases/[schema_version]/[MLOD]_[MVD].sch`. Six MLODs have been defined in BuildingSync, the first four being in alignment with ASHRAE Standard 211:

| MLOD | MVD | Alignment to Std 211 | Std 211 Section |
|-----------|----------------------|-----------------|---|
| Level 000 | Audit | Preliminary Analysis | Section 5.2.3 |
| Level 100 | Audit | Level 1 | Section 6.1 |
| Level 200 | Audit | Level 2 | Section 6.2 |
| Level 300 | Audit | Level 3 | Section 6.3 |
| Level 400 | Audit | Not Applicable | Not Applicable |
| Level 500 | Audit | Not Applicable | Not Applicable |


The `lib` directory provides a library of general purpose Schematron functions used within the individual Schematron documents.  These functions are designed to be used by others with use cases outside of the Levels defined above.  Narrative overviews for the different levels can be found in `docs`.

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
$ BUNDLE_GEMFILE=Gemfile-sch bundle exec rake spec SPEC=spec/lib/scenario_elements_spec.rb # run tests in single file
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

| File                                                                                                                                                                      | Specified For  | System Type                                       | Translate Tested | Simulate Tested | [MLOD](#mlod-definitions) | [MVD](#mvd)              | Validates Against              | Description                                                                                                                                    |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------------------------------------------------|------------------|-----------------|------|-----------------------|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| [L000_OpenStudio_Simulation_01.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_01.xml) | Building       | VAV with reheat                                   | TRUE             | TRUE            | L000 | OpenStudio_Simulation | [L000_OpenStudio_Simulation.sch](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/L000_OpenStudio_Simulation.sch) | No system-type actually declared.  System inferred from OpenStudio Standards based on Building's OccupancyClassification and Gross floor area. |
| [L000_OpenStudio_Simulation_02.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_02.xml) | Building       | PSZ-AC with gas reheat                            | TRUE             | TRUE            | L000 | OpenStudio_Simulation | [L000_OpenStudio_Simulation.sch](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/L000_OpenStudio_Simulation.sch) | No system-type actually declared.  System inferred from OpenStudio Standards based on Building's OccupancyClassification and Gross floor area. |
| [L100_OpenStudio_Simulation_01.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L100_OpenStudio_Simulation_01.xml) | Section-Retail | PSZ-AC with gas reheat                            | TRUE             | TRUE            | L100 | OpenStudio_Simulation | [L100_OpenStudio_Simulation.sch](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/L100_OpenStudio_Simulation.sch)                           | Packaged Rooftop Air Conditioner is mapped to PSZ-AC with gas reheat.                                                                          |
| [L100_OpenStudio_Simulation_01.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/examples/L100_OpenStudio_Simulation_01.xml) | Section-Office | PVAV with PFP boxes                               | TRUE             | TRUE            | L100 | OpenStudio_Simulation | [L100_OpenStudio_Simulation.sch](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/spec/use_cases/schema2.0.0/L100_OpenStudio_Simulation.sch)                           | Packaged Rooftop VAV with Electric Reheat is mapped as PVAV with PFP boxes                                                                     |
| [PSZ-AC-CDM-001.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/examples/HVACSystems/PSZ-AC-CDM-001.xml)                                              | Section        | PSZ-AC                                            | N/A            | N/A           | L200 | Audit                 | None                           | Example of constructing more complex, L200 system.                                                                                             |
| [PSZ-HP-CDM-001.xml](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/examples/HVACSystems/PSZ-HP-CDM-001.xml)                                              | Section        | PSZ-HP                                            | N/A            | N/A           | L200 | Audit                 | None                           | Example of constructing more complex, L200 system.                                                                                             |


## Lighting System Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|

## Premise Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|

# Contributing
See [Contributions and Schematron](docs/Contributions%20and%20Schematron.md)
