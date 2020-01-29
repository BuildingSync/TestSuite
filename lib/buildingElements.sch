<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="contacts.sch#con.nameEmailPhone"/>
<!--  For logic pertaining to a Building element. -->
  
  <!--    Required elements for L000 at the building level -->
  <pattern id="be.L000BuildingInfo">
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:PremisesName">
        auc:PremisesName must be specified for element: <name/>
      </assert>
      <assert test="auc:BuildingClassification">
        auc:BuildingClassification must be specified for element: <name/>
      </assert>
      <assert test="auc:OccupancyClassification">
        auc:OccupancyClassification must be specified for element: <name/>
      </assert>
      <assert test="auc:YearOfConstruction">
        auc:YearOfConstruction must be specified for element: <name/>
      </assert>
    </rule>
  </pattern>
  

  <pattern id="be.mainDetails">
    <let name="numContacts" value="count(//auc:Contacts/auc:Contact)"/>
    <let name="numAuditors" value="count(//auc:Contacts/auc:Contact/auc:ContactRoles/auc:ContactRole[text()='Energy Auditor'])"/>
    <let name="numOwners" value="count(//auc:Contacts/auc:Contact/auc:ContactRoles/auc:ContactRole[text()='Owner'])"/>
    <rule context="auc:Contacts">
      <assert test="$numContacts >= 2">
        A minimum of two contacts are required.  Current: <value-of select="$numContacts"/>
      </assert>
      <assert test="$numAuditors >= 1">
        There must be atleast one Energy Auditor defined.  Current: <value-of select="$numAuditors"/>
      </assert>
      <assert test="$numOwners >= 1">
        There must be atleast one Owner defined.  Current: <value-of select="$numOwners"/>
      </assert>
    </rule>
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:PremisesName">
        auc:PremisesName must be specified for element: <name/>
      </assert>
      <assert test="auc:BuildingClassification">
        auc:BuildingClassification must be specified for element: <name/>
      </assert>
      <assert test="auc:OccupancyClassification">
        auc:OccupancyClassification must be specified for element: <name/>
      </assert>
      <assert test="auc:YearOfConstruction">
        auc:YearOfConstruction must be specified for element: <name/>
      </assert>
      <assert test="auc:BuildingAutomationSystem">
        auc:BuildingAutomationSystem must be specified for element: <name/>
      </assert>
      <assert test="auc:HistoricalLandmark">
        auc:HistoricalLandmark must be specified for element: <name/>
      </assert>
      <assert test="auc:PercentOccupiedByOwner">
        auc:PercentOccupiedByOwner must be specified for element: <name/>
      </assert>
      <assert test="auc:PercentLeasedByOwner">
        auc:PercentLeasedByOwner must be specified for element: <name/>
      </assert>
      <assert test="auc:ConditionedFloorsAboveGrade">
        auc:ConditionedFloorsAboveGrade must be specified for element: <name/>
      </assert>
      <assert test="auc:ConditionedFloorsBelowGrade">
        auc:ConditionedFloorsBelowGrade must be specified for element: <name/>
      </assert>
      <assert test="auc:FloorsAboveGrade or auc:UnconditionedFloorsAboveGrade">
        auc:FloorsAboveGrade or auc:UnconditionedFloorsAboveGrade must be specified for element: <name/>
      </assert>
      <assert test="auc:FloorsBelowGrade or auc:UnconditionedFloorsBelowGrade">
        auc:FloorsBelowGrade or auc:UnconditionedFloorsBelowGrade must be specified for element: <name/>
      </assert>
    </rule>
<!--    Warnings (i.e. Recommended items) -->
    <rule context="auc:Buildings/auc:Building" role="warn">
      <assert test="auc:YearOfLastEnergyAudit">
        auc:YearOfLastEnergyAudit is recommended for element: <name/>
      </assert>
      <assert test="auc:RetrocommissioningDate">
        auc:RetrocommissioningDate is recommended for element: <name/>
      </assert>
    </rule>
  </pattern>
  
<!--  Doesn't handle complex address types -->
  <pattern id="be.simpleLocationDetails">
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:Address/auc:City and auc:Address/auc:State and 
                    (auc:Address/auc:PostalCode or auc:Address/auc:PostalCodePlus4)">
        Standard 211 requires an auc:City, auc:State, and auc:PostalCode or auc:PostalCodePlus4 be defined for element: <name/>
      </assert>
      <assert test="auc:Address/auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress">
        Standard 211 requires an auc:StreetAddress be defined for element: <name/>
      </assert>
    </rule>
  </pattern>
</schema>