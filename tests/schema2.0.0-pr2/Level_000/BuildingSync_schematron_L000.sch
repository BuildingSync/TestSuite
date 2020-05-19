<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt1">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
<!--  L000 -->
  <phase id="L000AuditRequirements">
    <active pattern="root.oneOfEachUntilBuilding"/>
    <active pattern="be.L000"/>
    <active pattern="sbe.cityStateOrClimateZone"/>
    <active pattern="be.fa.haveTypeAndValue"/>
    <active pattern="be.fa.oneGrossFloorArea"/>
  </phase>
  
  <phase id="L000SimulationRequirements">
    <active pattern="root.oneOfEachUntilBuilding"/>
    <active pattern="root.oneOfEachFacilityUntilScenario"/>
    <active pattern="be.L000"/>
    <active pattern="sbe.cityStateOrClimateZone"/>
    <active pattern="sc.baseline"/>
    <active pattern="be.fa.haveTypeAndValue"/>
    <active pattern="be.fa.oneGrossFloorArea"/>
  </phase>

  <include href="../../../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachFacilityUntilScenario"/>
  <include href="../../../lib/siteBuildingElements.sch#sbe.cityStateOrClimateZone"/>
  <include href="../../../lib/scenarioElements.sch#sc.baseline"/>
  <include href="../../../lib/buildingElements.sch#be.L000"/>
  <include href="../../../lib/floorAreaTests.sch#fa.oneGrossType"/>
  <include href="../../../lib/floorAreaTests.sch#fa.haveTypeAndValue"/>
<!--  Instantiate abstract patterns for L000 use case -->
  <pattern id="be.fa.haveTypeAndValue" is-a="fa.haveTypeAndValue">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
  </pattern>
  <pattern id="be.fa.oneGrossFloorArea" is-a="fa.oneGrossType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
  </pattern>

</schema>
