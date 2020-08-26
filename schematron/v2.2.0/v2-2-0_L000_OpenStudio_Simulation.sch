<?xml version='1.0' encoding='ASCII'?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:phase id="preliminary_analysis" see="Based on ASHRAE 211 5.2.3">
    <sch:active pattern="document_structure_prerequisites_building_info"/>
    <sch:active pattern="building_info"/>
    <sch:active pattern="document_structure_prerequisites_system_requirements"/>
    <sch:active pattern="system_requirements"/>
    <sch:active pattern="document_structure_prerequisites_measure_requirements"/>
    <sch:active pattern="measure_requirements"/>
    <sch:active pattern="document_structure_prerequisites_scenario_requirements"/>
    <sch:active pattern="scenario_requirements"/>
  </sch:phase>
  <sch:pattern see="" id="document_structure_prerequisites_building_info">
    <sch:title>Document Structure Prerequisites Building Info</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="building_info">
    <sch:title>Building Info</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building">
      <sch:assert test="(auc:Address/auc:City and auc:Address/auc:State) or auc:ClimateZoneType/auc:ASHRAE/auc:ClimateZone or auc:ClimateZoneType/auc:CaliforniaTitle24/auc:ClimateZone" role="">(auc:Address/auc:City and auc:Address/auc:State) or auc:ClimateZoneType/auc:ASHRAE/auc:ClimateZone or auc:ClimateZoneType/auc:CaliforniaTitle24/auc:ClimateZone</sch:assert>
      <sch:assert test="auc:PremisesName" role="">auc:PremisesName</sch:assert>
      <sch:assert test="auc:BuildingClassification" role="">auc:BuildingClassification</sch:assert>
      <sch:assert test="auc:OccupancyClassification" role="">auc:OccupancyClassification</sch:assert>
      <sch:assert test="auc:FloorAreas/auc:FloorArea[auc:FloorAreaType='Gross' and auc:FloorAreaValue]" role="">auc:FloorAreas/auc:FloorArea[auc:FloorAreaType='Gross' and auc:FloorAreaValue]</sch:assert>
      <sch:assert test="auc:YearOfConstruction" role="">auc:YearOfConstruction</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="document_structure_prerequisites_system_requirements">
    <sch:title>Document Structure Prerequisites System Requirements</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="system_requirements">
    <sch:title>System Requirements</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility">
      <sch:assert test="auc:Systems" role="">auc:Systems</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="document_structure_prerequisites_measure_requirements">
    <sch:title>Document Structure Prerequisites Measure Requirements</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="measure_requirements">
    <sch:title>Measure Requirements</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures">
      <sch:assert test="count(auc:Measure) &gt;= 1" role="">count(auc:Measure) &gt;= 1</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="document_structure_prerequisites_scenario_requirements">
    <sch:title>Document Structure Prerequisites Scenario Requirements</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="scenario_requirements">
    <sch:title>Scenario Requirements</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios">
      <sch:assert test="count(auc:Scenario[@ID='Baseline' and auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref='Baseline' and auc:ScenarioName='Baseline']) = 1" role="">count(auc:Scenario[@ID='Baseline' and auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref='Baseline' and auc:ScenarioName='Baseline']) = 1</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
