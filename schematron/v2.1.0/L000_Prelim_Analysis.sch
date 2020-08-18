<?xml version='1.0' encoding='ASCII'?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <sch:phase id="preliminary_analysis" see="ASHRAE 211 5.2.3">
    <sch:active pattern="document_structure_prerequisites_measured_scenario"/>
    <sch:active pattern="measured_scenario"/>
    <sch:active pattern="document_structure_prerequisites_benchmark_scenario"/>
    <sch:active pattern="benchmark_scenario"/>
  </sch:phase>
  <sch:pattern see="" id="document_structure_prerequisites_measured_scenario">
    <sch:title>Document Structure Prerequisites Measured Scenario</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID</sch:assert>
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="ASHRAE 211 5.2.3.1 and 5.2.3.2" id="measured_scenario">
    <sch:title>Measured Scenario</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID">
      <sch:assert test="//auc:Buildings/auc:Building[@ID = current()/@IDref]" role="">Scenario of Measured type must be linked to the Building</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]">
      <sch:assert test="auc:AllResourceTotals/auc:AllResourceTotal/auc:SiteEnergyUseIntensity" role="">auc:AllResourceTotals/auc:AllResourceTotal/auc:SiteEnergyUseIntensity</sch:assert>
      <sch:assert test="auc:AllResourceTotals/auc:AllResourceTotal/auc:EnergyCostIndex" role="">auc:AllResourceTotals/auc:AllResourceTotal/auc:EnergyCostIndex</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="" id="document_structure_prerequisites_benchmark_scenario">
    <sch:title>Document Structure Prerequisites Benchmark Scenario</sch:title>
    <sch:rule context="/">
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID</sch:assert>
      <sch:assert test="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Benchmark" role="ERROR">/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Benchmark</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern see="ASHRAE 211 5.2.3.3" id="benchmark_scenario">
    <sch:title>Benchmark Scenario</sch:title>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID">
      <sch:assert test="//auc:Buildings/auc:Building[@ID = current()/@IDref]" role="">Scenario of Benchmark type must be linked to the Building</sch:assert>
    </sch:rule>
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Benchmark">
      <sch:assert test="count(auc:BenchmarkType/*) &gt; 0" role="">count(auc:BenchmarkType/*) &gt; 0</sch:assert>
      <sch:assert test="auc:BenchmarkTool" role="">auc:BenchmarkTool</sch:assert>
      <sch:assert test="auc:BenchmarkYear" role="">auc:BenchmarkYear</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
