<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
<!--  
    For logic that pertains to either a Site OR a Building element.  
-->
  
  <!--  
    This pattern checks that: atleast 1 city and 1 state OR 
    1 climate zone are specified at the site OR building level.
    A warning is issued if more than one of each element is specified.
  -->
  <pattern id="sbe.cityStateOrClimateZone">
    <let name="cityCount" value="count(//auc:Site//auc:Address/auc:City)"/>
    <let name="stateCount" value="count(//auc:Site//auc:Address/auc:State)"/>
    <let name="climateZoneCount" value="count(//auc:Site//auc:ClimateZoneType//auc:ClimateZone)"/>
    <rule context="auc:Site" role="warn">
      <report test="$cityCount > 1 or $stateCount > 1 or $climateZoneCount > 1">
        You have more than one city, state, or climate zone defined.  It is expected that a Site and Building
        will share the same City/State and Climate Zone.  
        cityCount: <value-of select="$cityCount"/>
        stateCount: <value-of select="$stateCount"/>
        climateZoneCount: <value-of select="$climateZoneCount"/>
      </report>
    </rule>
    <rule context="auc:Site">
      <assert test="($cityCount = 1 and $stateCount = 1) or ($climateZoneCount = 1)">
        Must specify either: 1 city and 1 state OR 1 climate zone at the site OR building level.
        cityCount: <value-of select="$cityCount"/>
        stateCount: <value-of select="$stateCount"/>
        climateZoneCount: <value-of select="$climateZoneCount"/>
      </assert>
    </rule>
  </pattern>
</schema>