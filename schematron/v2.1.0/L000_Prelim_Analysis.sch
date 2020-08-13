<?xml version='1.0' encoding='ASCII'?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:phase id="preliminary_analysis" see="ASHRAE 211 5.2.3">
    <sch:active pattern="document_structure"/>
    <sch:active pattern="measured_scenario"/>
    <sch:active pattern="benchmark_scenario"/>
    <sch:active pattern="resource_use"/>
  </sch:phase>
  <sch:pattern see="" id="document_structure">
    <sch:title>Document Structure</sch:title>
    <sch:rule context="/">
      <sch:assert test="count(auc:BuildingSync) = 1" role="">count(auc:BuildingSync) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync">
      <sch:assert test="count(auc:Facilities) = 1" role="">count(auc:Facilities) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities">
      <sch:assert test="count(auc:Facility) = 1" role="">count(auc:Facility) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility">
      <sch:assert test="count(auc:Sites) = 1" role="">count(auc:Sites) = 1</sch:assert>
      <sch:assert test="count(auc:Reports) = 1" role="">count(auc:Reports) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites">
      <sch:assert test="count(auc:Site) = 1" role="">count(auc:Site) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site">
      <sch:assert test="count(auc:Buildings) = 1" role="">count(auc:Buildings) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings">
      <sch:assert test="count(auc:Building) = 1" role="">count(auc:Building) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports">
      <sch:assert test="count(auc:Report) &gt;= 1" role="">count(auc:Report) &gt;= 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report">
      <sch:assert test="count(auc:Scenarios) = 1" role="">count(auc:Scenarios) = 1</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios">
      <sch:assert test="count(auc:Scenario) &gt;= 1" role="">count(auc:Scenario) &gt;= 1</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="ASHRAE 211 5.2.3.1 and 5.2.3.2" id="measured_scenario">
    <sch:title>Measured Scenario</sch:title>
    <sch:rule context="//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID">
      <sch:assert test="//auc:Buildings/auc:Building[@ID = current()/@IDref]" role="">Scenario of Measured type must be linked to the Building</sch:assert>
    </sch:rule>
    <sch:rule context="//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]">
      <sch:assert test="auc:AllResourceTotals/auc:AllResourceTotal/auc:SiteEnergyUseIntensity" role="">auc:AllResourceTotals/auc:AllResourceTotal/auc:SiteEnergyUseIntensity</sch:assert>
      <sch:assert test="auc:AllResourceTotals/auc:AllResourceTotal/auc:EnergyCostIndex" role="">auc:AllResourceTotals/auc:AllResourceTotal/auc:EnergyCostIndex</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="ASHRAE 211 5.2.3.3" id="benchmark_scenario">
    <sch:title>Benchmark Scenario</sch:title>
    <sch:rule context="//auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID">
      <sch:assert test="//auc:Buildings/auc:Building[@ID = current()/@IDref]" role="">Scenario of Benchmark type must be linked to the Building</sch:assert>
    </sch:rule>
    <sch:rule context="//auc:Scenario/auc:ScenarioType/auc:Benchmark">
      <sch:assert test="count(auc:BenchmarkType/*) &gt; 0" role="">count(auc:BenchmarkType/*) &gt; 0</sch:assert>
      <sch:assert test="auc:BenchmarkTool" role="">auc:BenchmarkTool</sch:assert>
      <sch:assert test="auc:BenchmarkYear" role="">auc:BenchmarkYear</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="resource_use">
    <sch:title>Resource Use</sch:title>
    <sch:rule context="//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]">
      <sch:assert test="count(auc:ResourceUses) = 1" role="">count(auc:ResourceUses) = 1</sch:assert>
      <sch:assert test="auc:ResourceUses/auc:ResourceUse/auc:EnergyResource" role="">auc:ResourceUses/auc:ResourceUse/auc:EnergyResource</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
