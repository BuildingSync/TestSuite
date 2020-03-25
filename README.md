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

Due to dependency issues, there are currently two Gemfiles available in the repo.  Refer to the linked sections for specifics on how to use.
1. `Gemfile` - Use this for running Rake tasks for [running simulations](#running-simulations-rakefile)
1. `Gemfile-sch` - Use this for running Rake tasks for [tests](#tests)

__Note - there is no need to `rm -rf .bundle/` when switching between the above two scenarios.  Just run the below commands and then proceed as described in the linked sections__
```
$ bundle install --gemfile Gemfile --path .bundle/install
$ bundle install --gemfile Gemfile-sch --path .bundle/install
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

the [lib](lib) directory provides a library of general purpose Schematron functions used  within the individual Schematron xml documents.  These functions are designed to be used by others with use cases outside of the Levels defined above.  Narrative overviews for the different levels can be found in the [docs folder](<https://github.com/BuildingSync/TestSuite/blob/master/docs>).

# Rakefile
Rake tasks are currently used for two purposes, as outlined below.

## Tests
RSpec is used for running tests.  The tests are written around the following:
1. Testing individual Schematron functions within `lib/` are working correctly. In Progress
1. Testing that Schematron is working against Level Definition files.  TODO

```
$ bundle install --gemfile Gemfile-sch --path .bundle/install # if not previously run
$ BUNDLE_GEMFILE=Gemfile-sch bundle exec rake spec
```

More information on developing Schematron functions (and the required tests!) can be found in the [Contributions and Schematron](docs/Contributions%20and%20Schematron.md) document.

## Running Simulation Tests

Tests are also written for OpenStudio Simulation files.  Examples for how to use the BuildingSync-gem and the Translator class to run OpenStudio simulations using a BuildingSync XML file can be found in the `spec/simulations/**_spec.rb` files.  Since running all of the files through a simulation can be computationally expensive, tests are separated into two scenarios:
1. Translation of BuildingSync XML file into the OSM / OSW.
1. Simulation of the OSW.

Tests can be run as follows:

__Test that simulation files are translated__
```
$ BUNDLE_GEMFILE=Gemfile bundle exec translate
```

__Test that simulation files can be simulated__
```
$ BUNDLE_GEMFILE=Gemfile bundle exec simulate
```

### Outputs
Output directories will be created after running either the translation or simulation tests and are located in `spec/simulations/[schema-version]/[sim-file]/`.

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

# Contributing
See [Contributions and Schematron](docs/Contributions%20and%20Schematron.md)