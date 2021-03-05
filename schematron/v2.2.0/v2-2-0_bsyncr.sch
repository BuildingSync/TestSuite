<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:phase id="validate_bsyncr" see="">
    <sch:active pattern="document_structure_prerequisites_validate_bsyncr_pattern"/>
    <sch:active pattern="validate_bsyncr_pattern"/>
  </sch:phase>
  <sch:pattern see="" id="document_structure_prerequisites_validate_bsyncr_pattern">
    <sch:title>Document Structure Prerequisites Validate bsyncr pattern</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building</sch:assert>
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios</sch:assert>
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]</sch:assert>
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:TimeSeriesData/auc:TimeSeries" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:TimeSeriesData/auc:TimeSeries</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="validate_bsyncr_pattern">
    <sch:title>Validate bsyncr pattern</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building">
      <sch:assert test="auc:Longitude" role="">auc:Longitude</sch:assert>
      <sch:assert test="auc:Latitude" role="">auc:Latitude</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios">
      <sch:assert test="1 = count(auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured)" role="ERROR">There must be a single Measured Scenario</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]">
      <sch:let name="elec_resource_use_id" value="auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() = 'Electricity']/@ID"/>
      <sch:assert test="1 = count(auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() = 'Electricity'])" role="ERROR">There must be exactly one ResourceUse of type Electricity</sch:assert>
      <sch:assert test="12 &lt;= count(auc:TimeSeriesData/auc:TimeSeries[auc:ResourceUseID/@IDref = $elec_resource_use_id])" role="">There must be greater than or equal to 12 TimeSeries linked to the Electricity ResourceUse</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:TimeSeriesData/auc:TimeSeries">
      <sch:assert test="auc:StartTimestamp" role="">auc:StartTimestamp</sch:assert>
      <sch:assert test="auc:IntervalFrequency/text() = 'Month'" role="">auc:IntervalFrequency/text() = 'Month'</sch:assert>
      <sch:assert test="auc:IntervalReading" role="">auc:IntervalReading</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
