# Test Suite Levels
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