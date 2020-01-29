# Levels of Detail Definitions

The formal definitions for the levels below are defined using Schematron files, which are located at `tests/[schema_version]/[Level_XXX]/BuildingSync_schematron_LXXX.xml` in the [BuildingSync TestSuite Repo](https://github.com/BuildingSync/TestSuite).  

The levels are in alignment with the ASHRAE Standard 211 levels as defined below:

| Level | Alignment to Std 211 | Std 211 Section |
|-----------|----------------------|-----------------|
| Level 000 | Preliminary Analysis | Section 5.2.3 |
| Level 100 | Level 1 | Section 6.1 |
| Level 200 | Level 2 | Section 6.2 |
| Level 300 | Level 3 | Section 6.3 |
| Level 400 | Not Applicable | Not Applicable |
| Level 500 | Not Applicable | Not Applicable |

## Level 000
The Level 000 use case provides a high-level overview of a building and aligns with a typical Preliminary Energy Analysis.  It defines the minimum set of elements required to successfully translate the building from a BuildingSync document to an OpenStudio model using significant inferencing of engineering values based on leading standards (e.g., ASHRAE 901., 62.1, etc.).  Information required to define models at this level can typically be found from tax assessor data, publicly available data, annual energy consumption information, and through a brief discussion with the building owner.  Since little information is known about the building, many assumptions are made when performing the translation of a Level 000 BuildingSync model to a physics-based energy model.

| DEFINED | ASSUMED |
|---------------------------------|----------------------------------------------|
| Primary purpose of the building | Type and efficiency of systems |
| Total building area | Building geometry |
| Year built | Envelope constructions and insulation levels |
| Location |  |

## Level 100
The Level 100 use case extends the Level 000 use case.  The primary additions for the Level 100 model definition are summarized below.  For every space type defined by a Level 1 audit (Level 100 use case), a corresponding BuildingSync Section element is created, with an associated HVACSystem element, LightingSystem element, and PlugLoad element.

| DEFINED | ASSUMED |
|--------------------------------------------------------------------------------|--------------------------------------|
| Space types and information for all areas comprising > 20% of gross floor area | Envelope insulation levels and areas |
| Principal HVAC types | Building geometry |
| Principal lighting types | Equipment efficiencies |
| Plug loads | HVAC system capacities |

## Level 200
The Level 200 use case extends the Level 100 use case to include detailed system information and overall building geometry, as to mirror the ASHRAE Level 2 informational requirements.  While the level of detail provided in the Level 100 use case is necessary to provide a general summary of the main system types, it fails to capture system efficiencies and detailed system configurations.  Moreover, the general shape of the building is unknown, as well as any information about the envelope elements.  The intention of the Level 200 use case definition is to utilize the additional data provided from a Level 2 audit to further refine the model articulation.  As this is an area of active research, specific examples of this are outside the scope of this manuscript.

| DEFINED | ASSUMED |
|------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| Counts and definitions of primary HVAC, domestic hot water, and lighting equipment | Detailed building geometry, thermal and lighting zone configurations |
| General building shape | Equipment locations |
| Envelope areas, insulation levels, and general constructions | Detailed envelope constructions |