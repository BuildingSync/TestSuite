<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachUntilBuilding"/>
  <include href="../../../lib/rootElements.sch#root.oneOfEachFacilityUntilContacts"/>
  <include href="../../../lib/buildingElements.sch#be.simpleLocationDetails"/>
  <include href="../../../lib/buildingElements.sch#be.mainDetails"/>
  <include href="../../../lib/floorAreaTests.sch#fa.oneOfType"/>
  <include href="../../../lib/floorAreaTests.sch#fa.noneDefinedWarn"/>
  <include href="../../../lib/floorAreaTests.sch#fa.haveTypeAndValue"/>
  <include href="../../../lib/floorAreaTests.sch#fa.mechTypeChecks"/>
  <include href="../../../lib/contacts.sch#con.nameEmailPhone"/>
  
  <!--  L100 -->
  <phase id="L100AuditRequirements">
    <active pattern="root.oneOfEachUntilBuilding"/>
    <active pattern="root.oneOfEachFacilityUntilContacts"/>
    <active pattern="be.simpleLocationDetails"/>
    <active pattern="be.mainDetails"/>
    <active pattern="be.fa.haveTypeAndValue"/>
    <active pattern="be.fa.oneGross"/>
    <active pattern="be.fa.oneHeatedCooled"/>
    <active pattern="be.fa.oneHeated"/>
    <active pattern="be.fa.oneCooled"/>
    <active pattern="be.fa.oneVentilated"/>
    <active pattern="be.fa.mechTypeChecks"/>
    <active pattern="all.con.nameEmailPhone"/>
  </phase>
  
  
<!--  Instantiate abstract patterns for L100 use case -->
  
<!--  START FLOOR AREA CHECKS -->
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
    <param name="role" value="error"/>
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
  <!--  END FLOOR AREA CHECKS -->
  
  <!--  START CONTACT CHECKS -->
  
<!--  Require all contacts to have a name, email, and phone number fields defined -->
  <pattern id="all.con.nameEmailPhone" is-a="con.nameEmailPhone">
    <param name="parent" value="auc:Contact"/>
  </pattern>
  <!--  END CONTACT CHECKS -->
</schema>
