<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachFacilityUntilScenario"/>
  <include href="../../../lib/buildingElements.sch#be.L000BuildingInfo"/>
  <include href="../../../lib/floorElements.sch#fa.oneOfType"/>
  <include href="../../../lib/floorElements.sch#fa.haveTypeAndValue"/>
  <include href="../../../lib/scenarioElements.sch#sc.benchmarkType"/>
  <phase id="L000_PrelimAnalysis">
<!--    Ensure Building element is specified -->
    <active pattern="root.oneOfEachUntilBuilding"/>
<!--    Ensure atleast one Scenario element is specified -->
    <active pattern="root.oneOfEachFacilityUntilScenario"/>
<!--    Ensure a Benchmark scenario is specified -->
    <active pattern="sc.benchmarkType"/>
  </phase>
</schema>