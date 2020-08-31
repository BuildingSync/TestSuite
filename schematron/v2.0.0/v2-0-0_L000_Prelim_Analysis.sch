<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../lib/id.sch#id.facility"/>
  <include href="../lib/id.sch#id.site"/>
  <include href="../lib/id.sch#id.building"/>
  <include href="../lib/id.sch#id.section"/>
  <include href="../lib/id.sch#id.hvacSystem"/>
  <include href="../lib/id.sch#id.heatingPlant"/>
  <include href="../lib/id.sch#id.coolingPlant"/>
  <include href="../lib/id.sch#id.condenserPlant"/>
  <include href="../lib/id.sch#id.heatingSource"/>
  <include href="../lib/id.sch#id.coolingSource"/>
  <include href="../lib/id.sch#id.delivery"/>
  <include href="../lib/id.sch#id.otherHVACSystem"/>
  <include href="../lib/id.sch#id.lightingSystem"/>
  <include href="../lib/id.sch#id.domesticHotWaterSystem"/>
  <include href="../lib/id.sch#id.pumpSystem"/>
  <include href="../lib/id.sch#id.fanSystem"/>
  <include href="../lib/id.sch#id.motorSystem"/>
  <include href="../lib/id.sch#id.wallSystem"/>
  <include href="../lib/id.sch#id.roofSystem"/>
  <include href="../lib/id.sch#id.fenestrationSystem"/>
  <include href="../lib/id.sch#id.exteriorFloorSystem"/>
  <include href="../lib/id.sch#id.foundationSystem"/>
  <include href="../lib/id.sch#id.criticalITSystem"/>
  <include href="../lib/id.sch#id.plugLoad"/>
  <include href="../lib/id.sch#id.processLoad"/>
  <include href="../lib/id.sch#id.conveyanceSystem"/>
  <include href="../lib/id.sch#id.onsiteStorageTransmissionGenerationSystem"/>
  <include href="../lib/id.sch#id.airInfiltrationSystem"/>
  <include href="../lib/id.sch#id.schedule"/>
  <include href="../lib/id.sch#id.measure"/>
  <include href="../lib/id.sch#id.report"/>
  <include href="../lib/id.sch#id.scenario"/>
  <include href="../lib/id.sch#id.resourceUse"/>
  <include href="../lib/id.sch#id.qualification"/>
  <include href="../lib/id.sch#id.utility"/>
  <include href="../lib/id.sch#id.contact"/>
  <include href="../lib/id.sch#id.tenant"/>
  <include href="../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../lib/rootElements.sch#root.oneOfEachFacilityUntilScenario"/>
  <include href="../lib/buildingElements.sch#be.L000BuildingInfo"/>
  <include href="../lib/floorElements.sch#fa.oneOfType"/>
  <include href="../lib/floorElements.sch#fa.haveTypeAndValue"/>
  <include href="../lib/scenarioElements.sch#sc.be.hasBenchmarkType"/>
  <include href="../lib/scenarioElements.sch#sc.be.hasMeasured"/>
  <include href="../lib/scenarioElements.sch#sc.benchmarkType.mainDetails.L000"/>
  <include href="../lib/scenarioElements.sch#sc.measured.resourceUseReqs"/>
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
</schema>
