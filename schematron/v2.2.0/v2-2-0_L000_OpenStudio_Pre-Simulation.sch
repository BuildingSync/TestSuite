<?xml version='1.0' encoding='ASCII'?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:phase id="preliminary_analysis" see="Based on ASHRAE 211 5.2.3">
    <sch:active pattern="document_structure_prerequisites_building_info"/>
    <sch:active pattern="building_info"/>
    <sch:active pattern="location_info"/>
    <sch:active pattern="location_info"/>
    <sch:active pattern="location_info"/>
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
      <sch:assert test="auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)" role="">auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)</sch:assert>
      <sch:assert test="auc:PremisesName" role="">auc:PremisesName</sch:assert>
      <sch:assert test="auc:BuildingClassification" role="">auc:BuildingClassification</sch:assert>
      <sch:assert test="auc:OccupancyClassification" role="">auc:OccupancyClassification</sch:assert>
      <sch:assert test="auc:FloorAreas/auc:FloorArea[auc:FloorAreaType='Gross']/auc:FloorAreaValue" role="">auc:FloorAreas/auc:FloorArea[auc:FloorAreaType='Gross']/auc:FloorAreaValue</sch:assert>
      <sch:assert test="auc:YearOfConstruction" role="">auc:YearOfConstruction</sch:assert>
      <sch:assert test="//auc:Scenarios/auc:Scenario[auc:LinkedPremises/auc:Building/auc:LinkedBuildingID/@IDref = current()/@ID]/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled" role="">//auc:Scenarios/auc:Scenario[auc:LinkedPremises/auc:Building/auc:LinkedBuildingID/@IDref = current()/@ID]/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="location_info">
    <sch:title>Location Info</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Address">
      <sch:assert test="auc:City and auc:State" role="">auc:City and auc:State</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="location_info">
    <sch:title>Location Info</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:ClimateZoneType">
      <sch:assert test="auc:ASHRAE or auc:CaliforniaTitle24" role="">auc:ASHRAE or auc:CaliforniaTitle24</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="location_info">
    <sch:title>Location Info</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:ClimateZoneType[auc:ASHRAE or auc:CaliforniaTitle24]">
      <sch:assert test="//auc:ClimateZone" role="">//auc:ClimateZone</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
