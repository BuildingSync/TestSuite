<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <phase id="L000_PrelimAnalysis">
    <!--    Ensure Building element is specified -->
    <active pattern="root.oneOfEachUntilBuilding"/>
    <!--    Ensure atleast one Scenario element is specified -->
    <active pattern="root.oneOfEachFacilityUntilScenario"/>
    <!--    Ensure every Building is linked to a Benchmark Scenario -->
    <active pattern="sc.be.hasBenchmarkType"/>
    <!--    Ensure every Building is linked to a Measurement Scenario -->
    <active pattern="sc.be.hasMeasured"/>
    <!--    Ensure every Benchmark Scenario has necessary high-level info -->
    <active pattern="sc.benchmarkType.mainDetails.L000"/>
    <!--    Ensure every Measured Scenario has a ResourceUses declared with atleast one EnergyResource -->
    <active pattern="sc.measured.resourceUseReqs"/>
  </phase>
  <include href="lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="lib/rootElements.sch#root.oneOfEachFacilityUntilScenario"/>
  <include href="lib/buildingElements.sch#be.L000BuildingInfo"/>
  <include href="lib/floorElements.sch#fa.oneOfType"/>
  <include href="lib/floorElements.sch#fa.haveTypeAndValue"/>
  <include href="lib/scenarioElements.sch#sc.be.hasBenchmarkType"/>
  <include href="lib/scenarioElements.sch#sc.be.hasMeasured"/>
  <include href="lib/scenarioElements.sch#sc.benchmarkType.mainDetails.L000"/>
  <include href="lib/scenarioElements.sch#sc.measured.resourceUseReqs"/>
</schema>
