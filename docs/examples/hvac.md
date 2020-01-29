
# HVAC System Examples

| System Type | Level 000 | Level 100 | Level 200 |
|------------------------------------|--------------------|--------------------|-----------|
| PSZ System |  | [L100_Instance1.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_100/inputs/L100_Instance1.xml) |  |
| VAV |  | [L100_Instance2.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_100/inputs/L100_Instance2.xml) |  |
| Shared Boiler |  | TODO |  |
| DOAS & Radiant |  | TODO |  |
| Inferred from OpenStudio Standards | [L000_Instance1.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_000/inputs/L000_Instance1.xml) |  |  |
|  | [L000_Instance2.xml](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_000/inputs/L000_Instance1.xml) |  |  |


## HVAC Modeling Practices
Similar to other systems defined using BuildingSync, HVACSystems are defined at the `auc:Facility` level.  The purpose of this is to enable definition of central plants serving one or more sites, in turn serving one or more buildings.

### HVAC System Stub
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

### Linking Systems to Physical Elements
Everytime an `auc:HVACSystem` instance is created, the user is able to define `auc:LinkedPremises` ([link](https://github.com/BuildingSync/schema/blob/bfa4540a7d51fc3dda4e3816fcdb6639d73cd9b9/BuildingSync.xsd#L13759)), which are used to establish whether the system applies to one or more entire buildings, sections, spaces, or zones within buildings.  


## HVACSystemTypes
HVAC Systems in BuildingSync are of the ComplexType `auc:HVACSystemType`.  In general, users will be able to define multiples of each type of system, i.e. multiple heating and/or cooling plants or multiple heating/cooling systems.  HVAC Systems are broken up into the following.

### Plants
- HeatingPlants
- CoolingPlants
- CondenserPlants

### HeatingAndCoolingSystems
For each HeatingAndCoolingSystem, the user is able to:

- Define the Zoning Type
- Define HeatingSource(s), such as:
	- Connect to plant, ElectricResistance, Furnace, HeatPump, etc.
- Define CoolingSource(s) such as:
 	- Connect to plant, DX, EvaporativeCooler, etc.
- Define the Delivery ()

### DuctSystems
- Define detailed information about the duct system
  
### OtherHVACSystems