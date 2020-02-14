<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <!--  
    For logic that pertains to Occupancy
-->

<!--  
    Check that both the auc:TypicalOccupantUsageValue and auc:TypicalOccupantUsageUnits are specified.
    <severity> error
    <param> parent - an auc:TypicalOccupantUsage element
-->
  <pattern abstract="true" id="occ.typUsage.haveUnitsAndValue">
    <rule context="$parent">
      <assert test="auc:TypicalOccupantUsageUnits/text() and auc:TypicalOccupantUsageValue/text()">
        [ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: '<name/>'
      </assert>
    </rule>
  </pattern>
  
<!--
    Check the occupancy information for the auc:Section element is defined per 211 requirements
    <severity> error
    <param> parent - an auc:TypicalOccupantUsages element
-->
  <pattern abstract="true" id="occ.oneOfType.typicalUsageUnits">
    <rule context="$parent">
      <let name="v" value="'Hours per week'"/>
      <let name="typUnits" value="count(auc:TypicalOccupantUsage/auc:TypicalOccupantUsageUnits[text()=$v])"/>
      <assert test="$typUnits = 1">
        [ERROR] element 'auc:TypicalOccupantUsageUnits' MUST HAVE VALUE '<value-of select="$typUnits"/>' for '<name/>'
      </assert>
    </rule>
  </pattern>
  
<!--  
    Check that all auc:Occupancy Level elements have the auc:OccupantQuantityType and auc:OccupantQuantity child elements defined.
    <severity> error
    <param> parent - an auc:OccupancyLevels element
-->
  <pattern abstract="true" id="occ.levels.haveQuantityAndType">
    <rule context="$parent">
      <assert test="auc:OccupancyLevel/auc:OccupantQuantityType/text() and auc:OccupancyLevel/auc:OccupantQuantity/text()">
        auc:OccupancyLevel elements must specify both a auc:OccupancyQuantityType and auc:OccupantQuantity for <name/>
      </assert>
    </rule>
  </pattern>
  
<!--  
    Check that all auc:Occupancy Level elements have the auc:OccupantQuantityType and auc:OccupantQuantity child elements defined.
    <severity> error
    <param> parent - an auc:OccupancyLevels element
    <param> occLevelType - one of the standard enum values for auc:OccupancyQuantityType, such as 'Peak total occupants'
-->
  <pattern abstract="true" id="occ.levels.ofType">
    <rule context="$parent">
      <let name="countOccLevelType" value="count(auc:OccupancyLevel[auc:OccupantQuantityType = $occLevelType])"/>
      <assert test="$countOccLevelType = 1">
        An auc:OccupancyLevel element with auc:OccupancyQuantityType = <value-of select="$occLevelType"/> must be specified for <name/>.  Currently occurs: <value-of select="$countOccLevelType"/>
      </assert>
    </rule>
  </pattern>  
</schema>