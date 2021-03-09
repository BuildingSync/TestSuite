# HVAC Modeling Practices
Similar to other systems defined using BuildingSync, HVACSystems are defined as children of the `auc:Facility` level.  The purpose of this is to enable definition of central plants serving one or more sites, in turn serving one or more buildings.

## HVAC System Stub
An HVAC System lives as a child element of the `auc:Systems` element:
```xml
      <auc:Sites>
      ...
      </auc:Sites>
      <auc:Systems>
        <auc:HVACSystems>
          <auc:HVACSystem></auc:HVACSystem>
        </auc:HVACSystems>
      </auc:Systems>
      <auc:Schedules>
      ...
      </auc:Schedules>
```

## Linking Systems to Physical Elements
Everytime an `auc:HVACSystem` instance is created, the user is able to define `auc:LinkedPremises` ([link](https://github.com/BuildingSync/schema/blob/bfa4540a7d51fc3dda4e3816fcdb6639d73cd9b9/BuildingSync.xsd#L13759)), which are used to establish whether the system applies to one or more entire buildings, sections, spaces, or zones within buildings.  

# General Modeling Concepts

When creating detailed `auc:HVACSystem`s, other `auc:Systems` elements are required.  The most common include:
- `auc:FanSystems`
- `auc:PumpSystems`
- `auc:MotorSystems`

which are mainly required due to their prevalence in delivering energy to a space.

For example, let's consider a Packaged Single Zone Air Conditioning (PSZ-AC) unit with gas heating.  From BSync perspective, an 'air handler' is considered an `auc:Delivery`, that is, it is part of a system providing conditioning to a space.  As with mo

# HVACSystemTypes
HVAC Systems in BuildingSync are of the ComplexType `auc:HVACSystemType`.  In general, users will be able to define multiples of each type of system, i.e. multiple heating and/or cooling plants or multiple heating/cooling systems.  HVAC Systems are broken up into the following.

## Plants
- HeatingPlants
- CoolingPlants
- CondenserPlants

## HeatingAndCoolingSystems
For each HeatingAndCoolingSystem, the user is able to:
- Define the Zoning Type
- Define HeatingSource(s), such as:
  - Connect to plant, ElectricResistance, Furnace, HeatPump, etc.
- Define CoolingSource(s) such as:
  - Connect to plant, DX, EvaporativeCooler, etc.
- Define the Delivery ()