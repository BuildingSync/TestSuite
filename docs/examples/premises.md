# Premises Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|

## Modeling
In general, premises should be thought of as physical or logical bounding types.  This includes Facilities, Sites, Buildings, Sections, ThermalZones, and Spaces.

## Facilities
### Definition
No annotation definition provided.

### Uses
TODO

## Sites
### Definition
No annotation definition provided.

### Uses
Although no definition is provided, each Site should generally be constrained to a campus or a portfolio of related buildings.  For example, the University of Colorado has four main campuses: Boulder, Colorado Springs, Denver, and Anschutz Medical Campus.  Each of these should be logically contained as an individual site.  Additionally, a Site includes the area surrounding a building or a group of buildings, such as parking areas, sidewalks, etc.  For example, in a portfolio of buildings, each Site my often be contained to an individual building, but a Site designation is used to capture the parking lot area surrounding the building as well.

## Buildings
### Definition
A building is a single structure wholly or partially enclosed within exterior walls, or within exterior and abutment walls (party walls), and a roof, affording shelter to persons, animals, or property. A building can be two or more units held in the condominium form of ownership that are governed by the same board of managers.

### Uses


## Sections
### Definition
Physical section of building for which features are defined.  May be one or many.

### Uses
Sections are one of the more versatile premise features.  The enumerations for SectionType provide additional insight as to what they can be used for, and how they can be used:
- Whole building - The section is used to describe the whole building
- Space function - describes a space function (see ASHRAE standard 211)
- Component - describes a subspace of a primary premises such as HVAC zone, retails shops in a mall, etc.
- Tenant - describes a section for a tenant
- Virtual - describes a section loosely with potentially overlap with other sections and section types
- Other - not well-described by other types.


## ThermalZones
### Definition
Section of a building that share thermal control characteristics.  May be one or many.

## Spaces
### Definition
Areas of a building that share systems characteristics such as occupancy, plug loads, or lighting.