<?xml version='1.0' encoding='ASCII'?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:phase id="building_information" see="ASHRAE 211 6.1.1 and BSync-gem">
    <sch:active pattern="document_structure_prerequisites_basic_building_info"/>
    <sch:active pattern="basic_building_info"/>
    <sch:active pattern="document_structure_prerequisites_space_functions"/>
    <sch:active pattern="space_functions"/>
  </sch:phase>
  <sch:phase id="low_and_no_cost_measures" see="ASHRAE 211 6.1.5">
    <sch:active pattern="document_structure_prerequisites_low_cost_measures_tests"/>
    <sch:active pattern="low_cost_measures_tests"/>
  </sch:phase>
  <sch:pattern see="" id="document_structure_prerequisites_basic_building_info">
    <sch:title>Document Structure Prerequisites Basic Building Info</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="basic_building_info">
    <sch:title>Basic Building Info</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building">
      <sch:assert test="auc:PremisesName" role="">auc:PremisesName</sch:assert>
      <sch:assert test="auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)" role="">auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)</sch:assert>
      <sch:assert test="auc:FloorsAboveGrade" role="">auc:FloorsAboveGrade</sch:assert>
      <sch:assert test="auc:FloorsBelowGrade" role="">auc:FloorsBelowGrade</sch:assert>
      <sch:assert test="auc:ConditionedFloorsAboveGrade" role="">auc:ConditionedFloorsAboveGrade</sch:assert>
      <sch:assert test="auc:ConditionedFloorsBelowGrade" role="">auc:ConditionedFloorsBelowGrade</sch:assert>
      <sch:assert test="auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue" role="">auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue</sch:assert>
      <sch:assert test="auc:BuildingClassification" role="">auc:BuildingClassification</sch:assert>
      <sch:assert test="auc:OccupancyClassification" role="">auc:OccupancyClassification</sch:assert>
      <sch:assert test="auc:YearOfConstruction" role="">auc:YearOfConstruction</sch:assert>
      <sch:assert test="//auc:Scenarios/auc:Scenario[auc:LinkedPremises/auc:Building/auc:LinkedBuildingID/@IDref = current()/@ID]/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus/text()='Not Started'" role="">An auc:Building should be linked to an auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus='Not Started' in order to trigger a baseline OpenStudio model to be built</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Address">
      <sch:assert test="auc:City and auc:State" role="">auc:City and auc:State</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:ClimateZoneType">
      <sch:assert test="auc:ASHRAE or auc:CaliforniaTitle24" role="">auc:ASHRAE or auc:CaliforniaTitle24</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:ClimateZoneType[auc:ASHRAE or auc:CaliforniaTitle24]">
      <sch:assert test="//auc:ClimateZone" role="">//auc:ClimateZone</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="document_structure_prerequisites_space_functions">
    <sch:title>Document Structure Prerequisites Space Functions</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section[auc:SectionType/text() = 'Space function']" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section[auc:SectionType/text() = 'Space function']</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="ASHRAE 211 6.1.1.1.g/5.3.4" id="space_functions">
    <sch:title>Space Functions</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section[auc:SectionType/text() = 'Space function']">
      <sch:assert test="auc:OccupancyClassification" role="">auc:OccupancyClassification</sch:assert>
      <sch:assert test="auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue" role="">auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue</sch:assert>
      <sch:assert test="auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue &gt;= auc:FloorAreas/auc:FloorArea[auc:FloorAreaType/text() = 'Conditioned']/auc:FloorAreaValue" role="">Conditioned floor area cannot be greater than Gross floor area</sch:assert>
      <sch:assert test="auc:TypicalOccupantUsages/auc:TypicalOccupantUsage[auc:TypicalOccupantUsageUnits/text() = 'Hours per week']/auc:TypicalOccupantUsageValue" role="">auc:TypicalOccupantUsages/auc:TypicalOccupantUsage[auc:TypicalOccupantUsageUnits/text() = 'Hours per week']/auc:TypicalOccupantUsageValue</sch:assert>
      <sch:assert test="auc:TypicalOccupantUsages/auc:TypicalOccupantUsage[auc:TypicalOccupantUsageUnits/text() = 'Weeks per year']/auc:TypicalOccupantUsageValue" role="">auc:TypicalOccupantUsages/auc:TypicalOccupantUsage[auc:TypicalOccupantUsageUnits/text() = 'Weeks per year']/auc:TypicalOccupantUsageValue</sch:assert>
      <sch:assert test="auc:OccupancyLevels/auc:OccupancyLevel[auc:OccupantQuantityType/text() = 'Peak total occupants']/auc:OccupantQuantity" role="">auc:OccupancyLevels/auc:OccupancyLevel[auc:OccupantQuantityType/text() = 'Peak total occupants']/auc:OccupantQuantity</sch:assert>
      <sch:assert test="//auc:PlugLoad[auc:LinkedPremises/auc:Section/auc:LinkedSectionID/@IDref = current()/@ID]/auc:WeightedAverageLoad" role="">auc:Section[auc:SectionType='Space function'] must have a linked auc:PlugLoad with auc:WeightedAverageLoad</sch:assert>
      <sch:assert test="//auc:HVACSystem[auc:LinkedPremises/auc:Section/auc:LinkedSectionID/@IDref = current()/@ID]/auc:PrincipalHVACSystemType" role="">auc:Section[auc:SectionType='Space function'] must have a linked auc:HVACSystem/auc:PrincipalHVACSystem</sch:assert>
      <sch:assert test="//auc:LightingSystem[auc:LinkedPremises/auc:Section/auc:LinkedSectionID/@IDref = current()/@ID]/auc:LampType" role="">auc:Section[auc:SectionType='Space function'] must have a linked auc:LightingSystem with auc:LampType defined</sch:assert>
      <sch:assert test="//auc:LightingSystem[auc:LinkedPremises/auc:Section/auc:LinkedSectionID/@IDref = current()/@ID]/auc:LampType//auc:LampLabel" role="WARNING">auc:Section[auc:SectionType='Space function'] must have a linked auc:LightingSystem with auc:LampLabel defined</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="document_structure_prerequisites_low_cost_measures_tests">
    <sch:title>Document Structure Prerequisites Low Cost Measures Tests</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs/auc:MeasureID" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs/auc:MeasureID</sch:assert>
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="ASHRAE 211 6.1.5" id="low_cost_measures_tests">
    <sch:title>Low Cost Measures Tests</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures">
      <sch:assert test="auc:ReferenceCase/@IDref = //auc:Scenarios/auc:Scenario/@ID" role="">auc:ReferenceCase/@IDref = //auc:Scenarios/auc:Scenario/@ID</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:PackageOfMeasures[auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus='Not Started']/auc:ReferenceCase/@IDref = //auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod]/@ID]/auc:ScenarioType/auc:PackageOfMeasures">
      <sch:assert test="auc:MeasureIDs/auc:MeasureID" role="">A Package Of Measures to be simulated should be linked to atleast one auc:Measure</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs/auc:MeasureID">
      <sch:assert test="//auc:Measures/auc:Measure[@ID = current()/@IDref]" role="">//auc:Measures/auc:Measure[@ID = current()/@IDref]</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure">
      <sch:assert test="auc:SystemCategoryAffected" role="">auc:SystemCategoryAffected</sch:assert>
      <sch:assert test="auc:TechnologyCategories/auc:TechnologyCategory//auc:MeasureName" role="">auc:TechnologyCategories/auc:TechnologyCategory//auc:MeasureName</sch:assert>
      <sch:assert test="(auc:TechnologyCategories/auc:TechnologyCategory//auc:MeasureName/text() != 'Other') or auc:CustomMeasureName" role="">(auc:TechnologyCategories/auc:TechnologyCategory//auc:MeasureName/text() != 'Other') or auc:CustomMeasureName</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario">
      <sch:assert test="auc:LinkedPremises/auc:Building/auc:LinkedBuildingID/@IDref" role="">All Scenarios should be linked to a Building</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
