<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title>SEED</sch:title>
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:pattern>
    <!-- Test building -->
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site">
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:Address/auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Address/auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress" is REQUIRED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:Address/auc:City) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Address/auc:City" is REQUIRED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:Address/auc:State) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Address/auc:State" is REQUIRED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:Address/auc:PostalCode) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Address/auc:PostalCode" is REQUIRED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:Longitude) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Longitude" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:Latitude) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Latitude" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:Sections/auc:Section/auc:OccupancyClassification) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section/auc:OccupancyClassification" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:YearOfConstruction) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:YearOfConstruction" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:ConditionedFloorsAboveGrade) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:ConditionedFloorsAboveGrade" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:ConditionedFloorsBelowGrade) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:ConditionedFloorsBelowGrade" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:PremisesIdentifiers/auc:PremisesIdentifier[auc:IdentifierCustomName=&quot;City Custom Building ID&quot;]/auc:IdentifierValue) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:PremisesIdentifiers/auc:PremisesIdentifier[auc:IdentifierCustomName="City Custom Building ID"]/auc:IdentifierValue" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:PremisesIdentifiers/auc:PremisesIdentifier[auc:IdentifierCustomName=&quot;Custom ID 1&quot;]/auc:IdentifierValue) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:PremisesIdentifiers/auc:PremisesIdentifier[auc:IdentifierCustomName="Custom ID 1"]/auc:IdentifierValue" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType=&quot;Gross&quot;]/auc:FloorAreaValue) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType="Gross"]/auc:FloorAreaValue" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType=&quot;Net&quot;]/auc:FloorAreaValue) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType="Net"]/auc:FloorAreaValue" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Buildings/auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType=&quot;Footprint&quot;]/auc:FloorAreaValue) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType="Footprint"]/auc:FloorAreaValue" is RECOMMENDED
      </sch:assert>
    </sch:rule>
    <!-- Test measures -->
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure">
      <sch:assert test="count(.) = 1">element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/" is REQUIRED</sch:assert>
      <sch:assert test="count(./auc:TechnologyCategories/auc:TechnologyCategory/*[1]) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/*[1]" is REQUIRED
      </sch:assert>
      <sch:assert test="count(./auc:TechnologyCategories/auc:TechnologyCategory/*[1]//auc:MeasureName) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/*[1]//auc:MeasureName" is REQUIRED
      </sch:assert>
      <sch:assert test="count(./auc:ImplementationStatus) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:ImplementationStatus" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:MeasureScaleOfApplication) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:MeasureScaleOfApplication" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:SystemCategoryAffected) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:SystemCategoryAffected" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:Recommended) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:Recommended" is RECOMMENDED
      </sch:assert>
    </sch:rule>
    <!-- Test baseline scenario -->
    <!-- Note that we are unable to make strict requirements b/c of how Audit Template Tool uses scenarios -->
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios">
      <sch:assert test="auc:Scenario[@ID='Baseline']">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[@ID='Baseline']" is RECOMMENDED</sch:assert>
      <sch:assert test="auc:Scenario[@ID='Baseline']/auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref = 'Baseline'">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[@ID='Baseline']/auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref" is RECOMMENDED to be "Baseline"
      </sch:assert>
    </sch:rule>
    <!-- Test non-baseline scenarios -->
    <!-- Only test the scenarios that aren't ATT meta info -->
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[not(@ID='Baseline') and ./auc:ScenarioType/auc:PackageOfMeasures]">
      <sch:assert test="count(./auc:ScenarioName) = 1">element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioName" is REQUIRED</sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsSiteEnergy) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsSiteEnergy" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsSourceEnergy) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsSourceEnergy" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsCost) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsCost" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsByFuels/auc:AnnualSavingsByFuel[auc:EnergyResource=&quot;Electricity&quot;]/auc:AnnualSavingsNativeUnits) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsByFuels/auc:AnnualSavingsByFuel[auc:EnergyResource="Electricity"]/auc:AnnualSavingsNativeUnits" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsByFuels/auc:AnnualSavingsByFuel[auc:EnergyResource=&quot;Natural gas&quot;]/auc:AnnualSavingsNativeUnits) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:AnnualSavingsByFuels/auc:AnnualSavingsByFuel[auc:EnergyResource="Natural gas"]/auc:AnnualSavingsNativeUnits" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse=&quot;All end uses&quot;]/auc:SiteEnergyUse) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse="All end uses"]/auc:SiteEnergyUse" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse=&quot;All end uses&quot;]/auc:SiteEnergyUseIntensity) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse="All end uses"]/auc:SiteEnergyUseIntensity" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse=&quot;All end uses&quot;]/auc:SourceEnergyUse) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse="All end uses"]/auc:SourceEnergyUse" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse=&quot;All end uses&quot;]/auc:SourceEnergyUseIntensity) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:AllResourceTotals/auc:AllResourceTotal[auc:EndUse="All end uses"]/auc:SourceEnergyUseIntensity" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ResourceUses/auc:ResourceUse[auc:EnergyResource=&quot;Electricity&quot;]/auc:AnnualFuelUseConsistentUnits) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ResourceUses/auc:ResourceUse[auc:EnergyResource="Electricity"]/auc:AnnualFuelUseConsistentUnits" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ResourceUses/auc:ResourceUse[auc:EnergyResource=&quot;Electricity&quot;]/auc:AnnualPeakConsistentUnits) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ResourceUses/auc:ResourceUse[auc:EnergyResource="Electricity"]/auc:AnnualPeakConsistentUnits" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ResourceUses/auc:ResourceUse[auc:EnergyResource=&quot;Natural gas&quot;]/auc:AnnualFuelUseConsistentUnits) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ResourceUses/auc:ResourceUse[auc:EnergyResource="Natural gas"]/auc:AnnualFuelUseConsistentUnits" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:CalculationMethod/auc:Modeled) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:CalculationMethod/auc:Modeled" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:ResourceUses/auc:ResourceUse) &gt; 0">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ResourceUses/auc:ResourceUse" is RECOMMENDED
      </sch:assert>
      <sch:assert test="count(./auc:TimeSeriesData/auc:TimeSeries) &gt; 0">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:TimeSeriesData/auc:TimeSeries" is RECOMMENDED
      </sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
