# Floor Areas

Floor areas can be defined within any of the following BSync elements:
- `auc:Facility`
- `auc:Site`
- `auc:Building`
- `auc:Section`
- `auc:ThermalZone`
- `auc:Space`

Within the context of the Standard 211 audits, Floor Areas will primarily be defined at the following two levels:
1. `auc:Building` - this corresponds to the Floor Area definitions in the `All - Building` sheet of the 211 document.
2. `auc:Section` - this corresponds to the Floor Area definitions in the `All - Space Functions` sheet of the 211 document.

## Floor Area Types
A single floor area is categorized by its type.  The types are primarily important when it comes to mechanical type definitions since there are certain assumptions made in validating the floor areas (see below).  

| FloorAreaType | Category |
|-------------------|------------|
| Tenant | General |
| Common | General |
| Gross | General |
| Net | General |
| Finished | General |
| Footprint | General |
| Rentable | General |
| Occupied | General |
| Lighted | Lighting |
| Daylit | Lighting |
| Heated | Mechanical |
| Cooled | Mechanical |
| Conditioned | Mechanical |
| Unconditioned | Mechanical |
| Semi-conditioned | Mechanical |
| Heated and Cooled | Mechanical |
| Heated only | Mechanical |
| Cooled only | Mechanical |
| Ventilated | Mechanical |
| Enclosed | General |
| Non-Enclosed | General |
| Open | General |
| Lot | General |
| Custom | General |

An `auc:FloorArea` element should always declare a `auc:FoorAreaType`, and will typically be accompanied by a `auc:FloorAreaValue` as follows:
```xml
<auc:FloorArea>
  <auc:FloorAreaType>Gross</auc:FloorAreaType>
  <auc:FloorAreaValue>1234.0</auc:FloorAreaValue>
</auc:FloorArea>
```

# Standard 211 Audit Requirements
## Building Level: All - Building
For all audit levels, the following FloorAreaType declarations (accompanied by FloorAreaValue elements) MUST be defined at the Building Level (even if the value is 0.0):
- `Gross`
- `Heated and Cooled`
- `Heated only`
- `Cooled only`

A warning will appear if the following FloorAreaType IS NOT declared, although the document will still successfully validate through Schematron
- `Ventilated`

A warning will appear if the following FloorAreaTypes ARE declared, since no validation is done for these FloorAreaTypes and they have [overlapping defintions](#floor-area-validation):
- `Heated`
- `Cooled`

## Section Level: All - Space Functions
### Per Standard 211
Based on the `All - Space Types` sheet of the Standard 211 document, the following FloorAreaType (with sibling FloorAreaValue element) MUST be defined at the Section level:
- `Gross`

Additionally, a FloorArea element with a FloorAreaType=`Conditioned` MUST be defined for the section.  The conditioned area can be specified as either an `auc:FloorAreaValue` or an `auc:FloorAreaPercentage`.  The latter refers to the *percentage of the `Gross` FloorArea which is conditioned*.  For example, given the following:
```xml
<auc:FloorArea>
  <auc:FloorAreaType>Gross</auc:FloorAreaType>
  <auc:FloorAreaValue>1234.0</auc:FloorAreaValue>
</auc:FloorArea>
<auc:FloorArea>
  <auc:FloorAreaType>Conditioned</auc:FloorAreaType>
  <auc:FloorAreaPercentage>50</auc:FloorAreaPercentage>
</auc:FloorArea>
```

it is inferred that the square footage of this section which is conditioned is 617 sf.  As this convention is somewhat ambiguous (defining only the gross and conditioned floor area), the [following approach](#alternate-section-level-definition---recommended) is recommended for modeling at the Section level.

### Alternate Section Level Definition - Recommended!
As the Section level definition defined in the 211 spreadsheet is less verbose than BSync is capable of, and also provides ambiguity as to the type of conditioning (i.e. Heated only, Heated and Cooled, etc.), it is suggested to model FloorAreas at the section level in the same manner as at the [Building Level](#building-level-all---building).

## Floor Area Validation
The following assumptions are made regarding the floor areas:
- Equivalent Terms:
    - `Heated only` ~ `Heated` (recommend not to use `Heated`)
    - `Cooled only` ~ `Cooled` (recommend not to use `Cooled`)
- `Ventilated` should be thought of as Ventilated only
- Since the scope of Standard 211 is Commercial Buildings, spaces that are defined as `Heated and Cooled`, `Heated only`, or `Cooled only` are assumed to have ventilation provided as well
- `Gross = Conditioned + Unconditioned + Semi-conditioned`
- `Conditioned = Heated and Cooled + Heated only + Cooled only + Ventilated`

# Number of Floors
Per Standard 211 requirements, the following two fields MUST be declared at the Building Level:
- `auc:ConditionedFloorsAboveGrade`
- `auc:ConditionedFloorsBelowGrade`

BSync doesn't utilize a `Total Number of Floors` field due to its ambiguity with respect to where the floors are located (either above or below grade).  Instead, in addition to requiring the above two fields, BSync relies on declaration of the following fields:
- `auc:UnconditionedFloorsAboveGrade` or `auc:FloorsAboveGrade`
- `auc:UnconditionedFloorsBelowGrade` or `auc:FloorsBelowGrade`

## Floor Level Validation
Floor level validation only occurs in the following scenarios:
- All three elements are defined: `auc:FloorsAboveGrade`,  `auc:UnconditionedFloorsAboveGrade`, and `auc:ConditionedFloorsAboveGrade`
- All three elements are defined: `auc:FloorsBelowGrade`,  `auc:UnconditionedFloorsBelowGrade`, and `auc:ConditionedFloorsBelowGrade`

In the event a condition is true, the number of floors in the building is checked as such:
- `auc:FloorsAboveGrade = auc:UnconditionedFloorsAboveGrade + auc:ConditionedFloorsAboveGrade`
- `auc:FloorsBelowGrade = auc:UnconditionedFloorsBelowGrade + auc:ConditionedFloorsBelowGrade`