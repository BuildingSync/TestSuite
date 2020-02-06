# Systems
This document provides documentation for elements described within the `auc:Systems` element context.

# L100 Primary Systems
Per the [Level 100](https://github.com/BuildingSync/TestSuite/blob/master/docs/Level%20Definitions.md#level-100) definitions, for every `auc:Section` element defined, it is expected that there is *exactly one* of each of the following elements:
- `auc:HVACSystem`
- `auc:LightingSystem`
- `auc:PlugLoad`

Each of these elements refers back to the specific `auc:Section` within an `auc:Building` by using the `auc:LinkedSectionID` element with an `IDref` attribute pointing back to the `auc:Section`.  See the [example](#l100-example) for implementation details.

## L100 HVAC System Definition
Within the context of the `auc:HVACSystem` element, the following elements are required:
- `auc:PrimaryHVACSystemType`
- Link to the `auc:Section` which this system is meant to describe using the following: `auc:HVACSystem/auc:LinkedPremises/auc:Section/auc:LinkedSectionID IDref="SectionID-of-interest"`

## L100 Lighting System Definition
Within the context of the `auc:LightingSystem` element, the following elements are required:
- `auc:PrimaryLightingSystemType`
- Link to the `auc:Section` which this system is meant to describe using the following: `auc:PrimaryLightingSystemType/auc:LinkedPremises/auc:Section/auc:LinkedSectionID IDref="SectionID-of-interest"`

## L100 Plug Loads Definition
Unlike the HVAC and Lighting examples above, the Plug Load definition is requires slightly more care for modeling to get the desired effect (although not much).  Within the context of the `auc:PlugLoad` element, the following elements are required:
- `auc:PlugLoadType` with text value of: `Miscellaneous Electric Load`
- `auc:WeightedAverageLoad`
- Link to the `auc:Section` which this system is meant to describe using the following: `auc:PlugLoad/auc:LinkedPremises/auc:Section/auc:LinkedSectionID IDref="SectionID-of-interest"`

## L100 Example
In practice, this looks as follows (assume there is an `auc:Section` element with `ID="Section-Retail"` declared elsewhere in the document):
```xml
      <auc:Systems>
        <auc:HVACSystems>
          <auc:HVACSystem ID="HVAC-Retail">
            <auc:PrimaryHVACSystemType>Packaged Rooftop Air Conditioner</auc:PrimaryHVACSystemType>
            <auc:LinkedPremises>
              <auc:Section>
                <auc:LinkedSectionID IDref="Section-Retail"></auc:LinkedSectionID>
              </auc:Section>
            </auc:LinkedPremises>
          </auc:HVACSystem>
          ...
        </auc:HVACSystems>
        <auc:LightingSystems>
          <auc:LightingSystem ID="LightingSystemType-Retail">
            <auc:LinkedPremises>
              <auc:Section>
                <auc:LinkedSectionID IDref="Section-Retail"></auc:LinkedSectionID>
              </auc:Section>
            </auc:LinkedPremises>
            <auc:PrimaryLightingSystemType>Compact Fluorescent</auc:PrimaryLightingSystemType>
          </auc:LightingSystem>
          ...
        </auc:LightingSystems>
        <auc:PlugLoads>
          <auc:PlugLoad ID="PlugLoad-Retail">
            <auc:PlugLoadType>Miscellaneous Electric Load</auc:PlugLoadType>
            <auc:WeightedAverageLoad>0.5</auc:WeightedAverageLoad>
            <auc:LinkedPremises>
              <auc:Section>
                <auc:LinkedSectionID IDref="Section-Retail"></auc:LinkedSectionID>
              </auc:Section>
            </auc:LinkedPremises>
          </auc:PlugLoad>
          ...
        </auc:PlugLoads>
      </auc:Systems>
```
## L100 Validation
Validation of L100 requirements checks that, for every `auc:Section` element defined:
1. There is exactly one `auc:HVACSystem`, one `auc:LightingSystem`, and one `auc:PlugLoad` defined which refer back to the `auc:Section` of interest using the `IDref` attribute.
1.  The `auc:HVACSystem` element defines a valid `auc:PrimaryHVACSystemType`.  Valid refers to any valid enumeration provided by BuildingSync
1.  The `auc:LightingSystem` element defines a valid `auc:PrimaryLightingSystem`.  Valid refers to any valid enumeration provided by BuildingSync.
1. The `auc:PlugLoad` element defines:
    1. An `auc:PlugLoadType` with value equal to `Miscellaneous Electric Load`
    1. A valid `auc:WeightedAverageLoad` (which is of type xs:decimal)
