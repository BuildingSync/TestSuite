<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachFacilityUntilContacts"/>
  <include href="../../../lib/rootElements.sch#root.atleastOneReportInFacility"/>
  <include href="../../../lib/rootElements.sch#root.atleastOneScenarioInReport"/>
  <include href="../../../lib/buildingElements.sch#be.simpleLocationDetails"/>
  <include href="../../../lib/buildingElements.sch#be.mainDetails"/>
  <include href="../../../lib/floorAreaTests.sch#fa.maxOneOfEachType"/>
  <include href="../../../lib/floorAreaTests.sch#fa.oneOfType"/>
  <include href="../../../lib/floorAreaTests.sch#fa.noneDefinedWarn"/>
  <include href="../../../lib/floorAreaTests.sch#fa.haveTypeAndValue"/>
  <include href="../../../lib/floorAreaTests.sch#fa.mechTypeChecks"/>
  <include href="../../../lib/floorAreaTests.sch#fa.dontUse"/>
  <include href="../../../lib/floorAreaTests.sch#fa.oneOfMechType"/>
  <include href="../../../lib/floorAreaTests.sch#fa.conditionedPercentChecks"/>
  <include href="../../../lib/floorAreaTests.sch#fa.conditionedValueChecks"/>
  <include href="../../../lib/occupancyElements.sch#occ.oneOfType.typicalUsageUnits"/>
  <include href="../../../lib/occupancyElements.sch#occ.typUsage.haveUnitsAndValue"/>
  <include href="../../../lib/occupancyElements.sch#occ.levels.haveQuantityAndType"/>
  <include href="../../../lib/occupancyElements.sch#occ.levels.ofType"/>
  <include href="../../../lib/sectionElements.sch#sec.mainDetails"/>
  <include href="../../../lib/sectionElements.sch#sec.primarySystems"/>
  <include href="../../../lib/contacts.sch#con.nameEmailPhone"/>
  
  <!--  L100 Phase 1  -->
  <phase id="L100AuditRequirementsPhase1">
    <active pattern="root.oneOfEachUntilBuilding"/>
    <active pattern="root.oneOfEachFacilityUntilContacts"/>
    <active pattern="root.atleastOneReportInFacility"/>
    <active pattern="root.atleastOneScenarioInReport"/>
    <active pattern="allUnderBuilding.fa.dontUse"/>
    <active pattern="allUnderBuilding.fa.maxOneOfEachType"/>
    <active pattern="be.simpleLocationDetails"/>
    <active pattern="be.mainDetails"/>
    <active pattern="be.fa.haveTypeAndValue"/>
    <active pattern="be.fa.oneGross"/>
    <active pattern="be.fa.oneHeatedCooled"/>
    <active pattern="be.fa.oneHeated"/>
    <active pattern="be.fa.oneCooled"/>
    <active pattern="be.fa.oneVentilated"/>
    <active pattern="sec.sec.mainDetails"/>
    <active pattern="sec.sec.primarySystems"/>
    <active pattern="sec.fa.oneGross"/>
    <active pattern="sec.fa.oneOfMechType"/>
    <active pattern="sec.occ.typUsage.haveUnitsAndValue"/>
    <active pattern="sec.occ.oneOfType.hoursPerWeek"/>
    <active pattern="sec.occ.oneOfType.weeksPerYear"/>
    <active pattern="sec.occ.levels.haveQuantityAndType"/>
    <active pattern="sec.occ.levels.hasPeak"/>
    <active pattern="all.con.nameEmailPhone"/>
  </phase>
  
  <!--  L100 Phase 2  -->
  <phase id="L100AuditRequirementsPhase2">
    <active pattern="be.fa.mechTypeChecks"/>
    <active pattern="sec.fa.conditionedPercentChecks"/>
    <active pattern="sec.fa.conditionedValueChecks"/>
  </phase>
  
  
<!--  Instantiate abstract patterns for L100 use case -->

  
<!--  START FLOOR AREA CHECKS -->
  <pattern id="allUnderBuilding.fa.maxOneOfEachType" is-a="fa.maxOneOfEachType">
    <param name="parent" value="auc:Building//auc:FloorAreas"/> <!-- //auc:FloorAreas is the intended effect -->
  </pattern>
  
<!--  All Floor Areas must have a Type and Value at the Building Level-->
  <pattern id="be.fa.haveTypeAndValue" is-a="fa.haveTypeAndValue">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
  </pattern>
  
<!--  
    Building Level: atleast one FloorAreaType of: Gross, Heated and Cooled, Cooled Only, Heated Only.
    Warning given if Ventilated Area not defined
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
  <pattern id="be.fa.oneVentilated" is-a="fa.noneDefinedWarn">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Ventilated'"/>
  </pattern>
  <pattern id="be.fa.mechTypeChecks" is-a="fa.mechTypeChecks">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
  </pattern>
  <pattern id="allUnderBuilding.fa.dontUse" is-a="fa.dontUse">
    <param name="parent" value="auc:Building//auc:FloorAreas"/> <!-- //auc:FloorAreas is the intended effect -->
  </pattern>
  <!--  END FLOOR AREA CHECKS -->
  
  <!--  START CONTACT CHECKS -->
<!--  Require all contacts to have a name, email, and phone number fields defined -->
  <pattern id="all.con.nameEmailPhone" is-a="con.nameEmailPhone">
    <param name="parent" value="auc:Contact"/>
  </pattern>
  <!--  END CONTACT CHECKS -->
  
  <!--  START SPACE FUNCTION CHECKS -->
  <pattern id="sec.sec.mainDetails" is-a="sec.mainDetails">
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
  <pattern id="sec.fa.conditionedPercentChecks" is-a="fa.conditionedPercentChecks">
    <param name="parent" value="auc:Section/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType='Conditioned' and auc:FloorAreaPercentage]"/>
  </pattern>
  <pattern id="sec.fa.conditionedValueChecks" is-a="fa.conditionedValueChecks">
    <param name="parent" value="auc:Section/auc:FloorAreas/auc:FloorArea[auc:FloorAreaType='Conditioned' and auc:FloorAreaValue]"/>
  </pattern>
  
<!--  
    Section Level Occupancy Checks: one 'Hours per week' and one 'Weeks per year'
-->
  <pattern id="sec.occ.typUsage.haveUnitsAndValue" is-a="occ.typUsage.haveUnitsAndValue">
    <param name="parent" value="auc:Section/auc:TypicalOccupantUsages"/>
  </pattern>
  <pattern id="sec.occ.oneOfType.hoursPerWeek" is-a="occ.oneOfType.typicalUsageUnits">
    <param name="parent" value="auc:Section/auc:TypicalOccupantUsages"/>
    <param name="typUsageUnits" value="'Hours per week'"/>
  </pattern>
  <pattern id="sec.occ.oneOfType.weeksPerYear" is-a="occ.oneOfType.typicalUsageUnits">
    <param name="parent" value="auc:Section/auc:TypicalOccupantUsages"/>
    <param name="typUsageUnits" value="'Weeks per year'"/>
  </pattern>
  <pattern id="sec.occ.levels.haveQuantityAndType" is-a="occ.levels.haveQuantityAndType">
    <param name="parent" value="auc:Section/auc:OccupancyLevels"/>
  </pattern>
  <pattern id="sec.occ.levels.hasPeak" is-a="occ.levels.ofType">
    <param name="parent" value="auc:Section//auc:OccupancyLevels"/>
    <param name="occLevelType" value="'Peak total occupants'"/>
  </pattern>
  
<!--  
    Section Level System Checks: one of each:
    - PrimaryHVACSystemType
    - PrimaryLightingSystem
    - PlugLoadType = 'Miscellaneous Electric Load
-->
  <pattern id="sec.sec.primarySystems" is-a="sec.primarySystems">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']"/>
  </pattern>
  
  <!--  END SPACE FUNCTION CHECKS -->
  
</schema>
