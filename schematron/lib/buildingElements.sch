<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <!--  For logic pertaining to a Building element. -->
  <!--    Required elements for L000 at the building level -->
  <pattern id="be.L000BuildingInfo">
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:PremisesName" role="ERROR">element 'auc:PremisesName' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:BuildingClassification" role="ERROR">element 'auc:BuildingClassification' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:OccupancyClassification" role="ERROR">element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:YearOfConstruction" role="ERROR">element 'auc:YearOfConstruction' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
    </rule>
  </pattern>
  <pattern id="be.mainDetails.L100.sim">
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:PremisesName" role="ERROR">element 'auc:PremisesName' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:BuildingClassification" role="ERROR">element 'auc:BuildingClassification' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:OccupancyClassification" role="ERROR">element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:YearOfConstruction" role="ERROR">element 'auc:YearOfConstruction' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:ConditionedFloorsAboveGrade" role="ERROR">element 'auc:ConditionedFloorsAboveGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:ConditionedFloorsBelowGrade" role="ERROR">element 'auc:ConditionedFloorsBelowGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:FloorsAboveGrade or auc:UnconditionedFloorsAboveGrade" role="ERROR">element 'auc:FloorsAboveGrade' or 'auc:UnconditionedFloorsAboveGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:FloorsBelowGrade or auc:UnconditionedFloorsBelowGrade" role="ERROR">element 'auc:FloorsBelowGrade' or 'auc:UnconditionedFloorsBelowGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
    </rule>
  </pattern>
  <!--
    Check the main details for the Building element as required by 211.
-->
  <pattern id="be.mainDetails.L100.audit">
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:PremisesName" role="ERROR">element 'auc:PremisesName' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:BuildingClassification" role="ERROR">element 'auc:BuildingClassification' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:OccupancyClassification" role="ERROR">element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:YearOfConstruction" role="ERROR">element 'auc:YearOfConstruction' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:BuildingAutomationSystem" role="ERROR">element 'auc:BuildingAutomationSystem' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:HistoricalLandmark" role="ERROR">element 'auc:HistoricalLandmark' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:PercentOccupiedByOwner" role="ERROR">element 'auc:PercentOccupiedByOwner' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:PercentLeasedByOwner" role="ERROR">element 'auc:PercentLeasedByOwner' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:ConditionedFloorsAboveGrade" role="ERROR">element 'auc:ConditionedFloorsAboveGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:ConditionedFloorsBelowGrade" role="ERROR">element 'auc:ConditionedFloorsBelowGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:FloorsAboveGrade or auc:UnconditionedFloorsAboveGrade" role="ERROR">element 'auc:FloorsAboveGrade' or 'auc:UnconditionedFloorsAboveGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:FloorsBelowGrade or auc:UnconditionedFloorsBelowGrade" role="ERROR">element 'auc:FloorsBelowGrade' or 'auc:UnconditionedFloorsBelowGrade' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:YearOfLastEnergyAudit" role="WARNING">element 'auc:YearOfLastEnergyAudit' is RECOMMENDED for: '<name/>'</assert>
      <assert test="auc:RetrocommissioningDate" role="WARNING">element 'auc:RetrocommissioningDate' is RECOMMENDED for: '<name/>'</assert>
      <assert test="auc:YearOfLastMajorRemodel" role="WARNING">element 'auc:YearOfLastMajorRemodel' is RECOMMENDED for: '<name/>'</assert>
      <!--      <assert test="if (auc:ConditionedFloorsAboveGrade and auc:FloorsAboveGrade and auc:UnconditionedFloorsAboveGrade) then (auc:FloorsAboveGrade = auc:ConditionedFloorsAboveGrade + auc:UnconditionedFloorsAboveGrade) else (true())">The following statement must be true: auc:FloorsAboveGrade = auc:ConditionedFloorsAboveGrade + auc:UnconditionedFloorsAboveGrade</assert>-->
      <!--      <assert test="if (auc:ConditionedFloorsBelowGrade and auc:FloorsBelowGrade and auc:UnconditionedFloorsBelowGrade) then (auc:FloorsBelowGrade = auc:ConditionedFloorsBelowGrade + auc:UnconditionedFloorsBelowGrade) else (true())">The following statement must be true: auc:FloorsBelowGrade = auc:ConditionedFloorsBelowGrade + auc:UnconditionedFloorsBelowGrade</assert>-->
    </rule>
  </pattern>
  <!--
    Check the simple location details for the Building element as required by 211.
    This function doesn't handle complex address types, i.e auc:StreetAddressDetail/auc:Complex
    <severity> error
-->
  <pattern id="be.simpleLocationDetails">
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:Address/auc:City" role="ERROR">element 'auc:City' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:Address/auc:State" role="ERROR">element 'auc:State' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:Address/auc:PostalCode" role="ERROR">element 'auc:PostalCode' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:Address/auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress" role="ERROR">element 'auc:StreetAddress' within element 'auc:Address/auc:StreetAddressDetail/auc:Simplified' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
    </rule>
  </pattern>
  <!--  Check for Lat and Long at the building level-->
  <pattern id="be.latLong">
    <rule context="auc:Buildings/auc:Building">
      <assert test="auc:Latitude" role="ERROR">element 'auc:Latitude' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
      <assert test="auc:Longitude" role="ERROR">element 'auc:Longitude' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
    </rule>
  </pattern>
</schema>
