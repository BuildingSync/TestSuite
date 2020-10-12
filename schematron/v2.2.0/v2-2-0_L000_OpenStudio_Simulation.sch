<?xml version='1.0' encoding='ASCII'?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:phase id="preliminary_analysis" see="Based on ASHRAE 211 5.2.3">
    <sch:active pattern="document_structure_prerequisites_building_info"/>
    <sch:active pattern="building_info"/>
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
      <sch:assert test="//auc:Scenarios/auc:Scenario[auc:LinkedPremises/auc:Building/auc:LinkedBuildingID/@IDref = current()/@ID]/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled" role="">//auc:Scenarios/auc:Scenario[auc:LinkedPremises/auc:Building/auc:LinkedBuildingID/@IDref = current()/@ID]/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
