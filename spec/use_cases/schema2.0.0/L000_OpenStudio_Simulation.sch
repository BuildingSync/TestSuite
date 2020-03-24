<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachFacilityUntilScenario"/>
  <include href="../../../lib/siteBuildingElements.sch#sbe.cityStateOrClimateZone"/>
  <include href="../../../lib/scenarioElements.sch#sc.baseline.ID"/>
  <include href="../../../lib/scenarioElements.sch#sc.baseline.asPackageOfMeasures"/>
  <include href="../../../lib/buildingElements.sch#be.L000BuildingInfo"/>
  <include href="../../../lib/floorElements.sch#fa.oneOfType"/>
  <include href="../../../lib/floorElements.sch#fa.haveTypeAndValue"/>
  <phase id="L000_Simulation">
    <active pattern="root.oneOfEachUntilBuilding"/>
    <active pattern="root.oneOfEachFacilityUntilScenario"/>
    <active pattern="be.L000BuildingInfo"/>
    <active pattern="sbe.sbe.cityStateOrClimateZone"/>
    <active pattern="sc.baseline.ID"/>
    <active pattern="sc.baseline.asPackageOfMeasures"/>
    <active pattern="be.fa.haveTypeAndValue"/>
    <active pattern="be.fa.oneGrossFloorArea"/>
  </phase>
  <!--  Instantiate abstract patterns  -->
  <pattern id="be.fa.haveTypeAndValue" is-a="fa.haveTypeAndValue">
    <param name="parent" value="auc:Building/auc:FloorAreas/auc:FloorArea"/>
  </pattern>
  <pattern id="be.fa.oneGrossFloorArea" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Gross'"/>
  </pattern>
  <pattern id="sbe.sbe.cityStateOrClimateZone" is-a="sbe.cityStateOrClimateZone">
    <param name="parent" value="auc:Sites/auc:Site"/>
  </pattern>
</schema>
