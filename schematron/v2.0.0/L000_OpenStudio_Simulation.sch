<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <phase id="Check_IDs">
    <active pattern="id.airInfiltrationSystem"/>
    <active pattern="id.building"/>
    <active pattern="id.condenserPlant"/>
    <active pattern="id.contact"/>
    <active pattern="id.conveyanceSystem"/>
    <active pattern="id.coolingPlant"/>
    <active pattern="id.coolingSource"/>
    <active pattern="id.criticalITSystem"/>
    <active pattern="id.delivery"/>
    <active pattern="id.domesticHotWaterSystem"/>
    <active pattern="id.exteriorFloorSystem"/>
    <active pattern="id.facility"/>
    <active pattern="id.fanSystem"/>
    <active pattern="id.fenestrationSystem"/>
    <active pattern="id.foundationSystem"/>
    <active pattern="id.heatingPlant"/>
    <active pattern="id.heatingSource"/>
    <active pattern="id.hvacSystem"/>
    <active pattern="id.lightingSystem"/>
    <active pattern="id.measure"/>
    <active pattern="id.motorSystem"/>
    <active pattern="id.onsiteStorageTransmissionGenerationSystem"/>
    <active pattern="id.otherHVACSystem"/>
    <active pattern="id.plugLoad"/>
    <active pattern="id.processLoad"/>
    <active pattern="id.pumpSystem"/>
    <active pattern="id.qualification"/>
    <active pattern="id.report"/>
    <active pattern="id.resourceUse"/>
    <active pattern="id.roofSystem"/>
    <active pattern="id.scenario"/>
    <active pattern="id.schedule"/>
    <active pattern="id.section"/>
    <active pattern="id.site"/>
    <active pattern="id.tenant"/>
    <active pattern="id.utility"/>
    <active pattern="id.wallSystem"/>
  </phase>
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
  <include href="../../../lib/id.sch#id.facility"/>
  <include href="../../../lib/id.sch#id.site"/>
  <include href="../../../lib/id.sch#id.building"/>
  <include href="../../../lib/id.sch#id.section"/>
  <include href="../../../lib/id.sch#id.hvacSystem"/>
  <include href="../../../lib/id.sch#id.heatingPlant"/>
  <include href="../../../lib/id.sch#id.coolingPlant"/>
  <include href="../../../lib/id.sch#id.condenserPlant"/>
  <include href="../../../lib/id.sch#id.heatingSource"/>
  <include href="../../../lib/id.sch#id.coolingSource"/>
  <include href="../../../lib/id.sch#id.delivery"/>
  <include href="../../../lib/id.sch#id.otherHVACSystem"/>
  <include href="../../../lib/id.sch#id.lightingSystem"/>
  <include href="../../../lib/id.sch#id.domesticHotWaterSystem"/>
  <include href="../../../lib/id.sch#id.pumpSystem"/>
  <include href="../../../lib/id.sch#id.fanSystem"/>
  <include href="../../../lib/id.sch#id.motorSystem"/>
  <include href="../../../lib/id.sch#id.wallSystem"/>
  <include href="../../../lib/id.sch#id.roofSystem"/>
  <include href="../../../lib/id.sch#id.fenestrationSystem"/>
  <include href="../../../lib/id.sch#id.exteriorFloorSystem"/>
  <include href="../../../lib/id.sch#id.foundationSystem"/>
  <include href="../../../lib/id.sch#id.criticalITSystem"/>
  <include href="../../../lib/id.sch#id.plugLoad"/>
  <include href="../../../lib/id.sch#id.processLoad"/>
  <include href="../../../lib/id.sch#id.conveyanceSystem"/>
  <include href="../../../lib/id.sch#id.onsiteStorageTransmissionGenerationSystem"/>
  <include href="../../../lib/id.sch#id.airInfiltrationSystem"/>
  <include href="../../../lib/id.sch#id.schedule"/>
  <include href="../../../lib/id.sch#id.measure"/>
  <include href="../../../lib/id.sch#id.report"/>
  <include href="../../../lib/id.sch#id.scenario"/>
  <include href="../../../lib/id.sch#id.resourceUse"/>
  <include href="../../../lib/id.sch#id.qualification"/>
  <include href="../../../lib/id.sch#id.utility"/>
  <include href="../../../lib/id.sch#id.contact"/>
  <include href="../../../lib/id.sch#id.tenant"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachFacilityUntilScenario"/>
  <include href="../../../lib/siteBuildingElements.sch#sbe.cityStateOrClimateZone"/>
  <include href="../../../lib/scenarioElements.sch#sc.baseline.ID"/>
  <include href="../../../lib/scenarioElements.sch#sc.baseline.asPackageOfMeasures"/>
  <include href="../../../lib/buildingElements.sch#be.L000BuildingInfo"/>
  <include href="../../../lib/floorElements.sch#fa.oneOfType"/>
  <include href="../../../lib/floorElements.sch#fa.haveTypeAndValue"/>
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
