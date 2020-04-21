<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachFacilityUntilScenario"/>
  <include href="../../../lib/buildingElements.sch#be.L000BuildingInfo"/>
  <include href="../../../lib/floorElements.sch#fa.oneOfType"/>
  <include href="../../../lib/floorElements.sch#fa.haveTypeAndValue"/>
  <include href="../../../lib/scenarioElements.sch#be.sc.benchmarkType"/>
  <include href="../../../lib/scenarioElements.sch#be.sc.measured"/>
  <include href="../../../lib/scenarioElements.sch#sc.benchmarkType.mainDetails.L000"/>
  <include href="../../../lib/scenarioElements.sch#sc.measured.resourceUses"/>
  <phase id="L000_PrelimAnalysis">
    <!--    Ensure Building element is specified -->
    <active pattern="root.oneOfEachUntilBuilding"/>
    <!--    Ensure atleast one Scenario element is specified -->
    <active pattern="root.oneOfEachFacilityUntilScenario"/>
    <!--    Ensure every Building is linked to a Benchmark Scenario -->
    <active pattern="be.sc.benchmarkType"/>
    <!--    Ensure every Building is linked to a Measurement Scenario -->
    <active pattern="be.sc.measured"/>
    <!--    Ensure every Benchmark Scenario has necessary high-level info -->
    <active pattern="sc.benchmarkType.mainDetails.L000"/>
    <!--    Ensure every Measured Scenario has a ResourceUses declared with atleast one EnergyResource -->
    <active pattern="sc.measured.resourceUses"/>
  </phase>
</schema>
