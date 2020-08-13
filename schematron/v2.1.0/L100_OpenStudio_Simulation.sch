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
  <!--  L100 Phase 1  -->
  <phase id="L100_Simulation">
    <active pattern="root.oneOfEachUntilBuilding"/>
    <active pattern="root.atleastOneReportInFacility"/>
    <active pattern="root.atleastOneScenarioInReport"/>
    <active pattern="all.fa.maxOneOfEachType"/>
    <active pattern="all.fa.dontUse"/>
    <active pattern="all.fa.haveTypeAndValue"/>
    <active pattern="sbe.sbe.cityStateOrClimateZone"/>
    <active pattern="sc.baseline.ID"/>
    <active pattern="sc.baseline.asPackageOfMeasures"/>
    <active pattern="be.simpleLocationDetails"/>
    <active pattern="be.mainDetails.L100.sim"/>
    <active pattern="be.fa.oneGross"/>
    <active pattern="be.fa.oneHeatedCooled"/>
    <active pattern="be.fa.oneHeated"/>
    <active pattern="be.fa.oneCooled"/>
    <active pattern="be.fa.mechTypeChecks"/>
    <active pattern="sec.sec.mainDetails.L100.sim"/>
    <active pattern="sec.fa.oneGross"/>
    <active pattern="sec.fa.oneOfMechType"/>
    <active pattern="sec.fa.mechTypeChecks"/>
    <active pattern="sec.occ.typUsage.haveUnitsAndValue"/>
<!--    TypicalOccupantUsage='Hours per week' for each Section -->
    <active pattern="sec.occ.oneOfType.hoursPerWeek"/>
    <!--    TypicalOccupantUsage='Weeks per year' for each Section -->
    <active pattern="sec.occ.oneOfType.weeksPerYear"/>
    <active pattern="sec.occ.levels.haveQuantityAndType"/>
<!--    OccupancyLevel='Peak Total Occupants' for each Section-->
    <active pattern="sec.occ.levels.hasPeak"/>
<!--    Section level system checks: PrimaryHVACSystemType, PrimaryLightingSystemType, PlugLoad-->
    <active pattern="sec.primarySystems.L100"/>
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
  <include href="../../../lib/rootElements.sch#root.atleastOneReportInFacility"/>
  <include href="../../../lib/rootElements.sch#root.atleastOneScenarioInReport"/>
  <include href="../../../lib/siteBuildingElements.sch#sbe.cityStateOrClimateZone"/>
  <include href="../../../lib/scenarioElements.sch#sc.baseline.ID"/>
  <include href="../../../lib/scenarioElements.sch#sc.baseline.asPackageOfMeasures"/>
  <include href="../../../lib/buildingElements.sch#be.simpleLocationDetails"/>
  <include href="../../../lib/buildingElements.sch#be.mainDetails.L100.sim"/>
  <include href="../../../lib/floorElements.sch#fa.maxOneOfEachType"/>
  <include href="../../../lib/floorElements.sch#fa.oneOfType"/>
  <include href="../../../lib/floorElements.sch#fa.haveTypeAndValue"/>
  <include href="../../../lib/floorElements.sch#fa.mechTypeChecks"/>
  <include href="../../../lib/floorElements.sch#fa.dontUse"/>
  <include href="../../../lib/floorElements.sch#fa.oneOfMechType"/>
  <include href="../../../lib/occupancyElements.sch#occ.oneOfType.typicalUsageUnits"/>
  <include href="../../../lib/occupancyElements.sch#occ.typUsage.haveUnitsAndValue"/>
  <include href="../../../lib/occupancyElements.sch#occ.levels.haveQuantityAndType"/>
  <include href="../../../lib/occupancyElements.sch#occ.levels.oneOfType"/>
  <include href="../../../lib/sectionElements.sch#sec.mainDetails.L100.sim"/>
  <include href="../../../lib/sectionElements.sch#sec.primarySystems.L100"/>
  <!--  Instantiate abstract patterns for L100 use case -->
  <!--  START FLOOR AREA CHECKS -->
<!--  Ensure there is maximum one of each FloorAreaType in a FloorAreas -->
  <pattern id="all.fa.maxOneOfEachType" is-a="fa.maxOneOfEachType">
    <param name="parent" value="auc:FloorAreas"/>
    <!-- auc:FloorAreas is the intended effect, checks Buildings, Sections, etc. -->
  </pattern>
<!--  Don't use 'Heated' or 'Cooled' in any of the FloorAreaType text -->
  <pattern id="all.fa.dontUse" is-a="fa.dontUse">
    <param name="parent" value="auc:FloorAreas"/>
    <!-- auc:FloorAreas is the intended effect, checks Buildings, Sections, etc. -->
  </pattern>
  <!--  All Floor Areas must have a Type and Value -->
  <pattern id="all.fa.haveTypeAndValue" is-a="fa.haveTypeAndValue">
    <param name="parent" value="auc:FloorAreas/auc:FloorArea"/>
  </pattern>
<!--  Site or Building element to have a City and State or Climate Zone.-->
  <pattern id="sbe.sbe.cityStateOrClimateZone" is-a="sbe.cityStateOrClimateZone">
    <param name="parent" value="auc:Sites/auc:Site"/>
  </pattern>
  <!--
    Building Level: atleast one FloorAreaType of:
      Gross
      Heated and Cooled
      Cooled Only
      Heated Only
-->
  <pattern id="be.fa.oneGross" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Gross'"/>
  </pattern>
  <pattern id="be.fa.oneHeatedCooled" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Heated and Cooled'"/>
  </pattern>
  <pattern id="be.fa.oneCooled" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Cooled only'"/>
  </pattern>
  <pattern id="be.fa.oneHeated" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Heated only'"/>
  </pattern>
  <pattern id="be.fa.mechTypeChecks" is-a="fa.mechTypeChecks">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
  </pattern>

  <!--  END FLOOR AREA CHECKS -->
  <!--  START SPACE FUNCTION CHECKS -->
<!--  Check that auc:OccupancyClassification is specified for all Space function -->
  <pattern id="sec.sec.mainDetails.L100.sim" is-a="sec.mainDetails.L100.sim">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']"/>
  </pattern>
  <!--
    Section Level Floor Areas: one Gross and one of:
    - Conditioned
    - Heated and Cooled
    - Cooled only
    - Heated only
    - Ventilated
    Also check math for mechanical and gross floor areas
-->
  <pattern id="sec.fa.oneGross" is-a="fa.oneOfType">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Gross'"/>
  </pattern>
  <pattern id="sec.fa.oneOfMechType" is-a="fa.oneOfMechType">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']/auc:FloorAreas"/>
  </pattern>
  <pattern id="sec.fa.mechTypeChecks" is-a="fa.mechTypeChecks">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']/auc:FloorAreas"/>
  </pattern>
  <!--
    Section Level Occupancy Checks: one 'Hours per week' and one 'Weeks per year'
-->
  <pattern id="sec.occ.typUsage.haveUnitsAndValue" is-a="occ.typUsage.haveUnitsAndValue">
    <param name="parent" value="auc:Section/auc:TypicalOccupantUsages/auc:TypicalOccupantUsage"/>
  </pattern>
  <pattern id="sec.occ.oneOfType.hoursPerWeek" is-a="occ.oneOfType.typicalUsageUnits">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']/auc:TypicalOccupantUsages"/>
    <param name="typUsageUnits" value="'Hours per week'"/>
  </pattern>
  <pattern id="sec.occ.oneOfType.weeksPerYear" is-a="occ.oneOfType.typicalUsageUnits">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']/auc:TypicalOccupantUsages"/>
    <param name="typUsageUnits" value="'Weeks per year'"/>
  </pattern>
  <pattern id="sec.occ.levels.haveQuantityAndType" is-a="occ.levels.haveQuantityAndType">
    <param name="parent" value="auc:Section/auc:OccupancyLevels/auc:OccupancyLevel"/>
  </pattern>
  <pattern id="sec.occ.levels.hasPeak" is-a="occ.levels.oneOfType">
    <param name="parent" value="auc:Section/auc:OccupancyLevels"/>
    <param name="occLevelType" value="'Peak total occupants'"/>
  </pattern>
  <!--  END SPACE FUNCTION CHECKS -->
</schema>
