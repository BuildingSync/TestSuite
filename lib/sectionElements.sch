<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <!--  
    For logic that pertains to Section elements
-->
  
<!--
    Check the main details for the Section element as required by 211.
    <param> parent - an auc:Section element
-->
  <pattern abstract="true" id="sec.mainDetails">
    <rule context="$parent" role="error">
      <assert test="auc:OccupancyClassification">
        auc:OccupancyClassification must be specified for <name/>
      </assert>
    </rule>
    <rule context="$parent" role="warn">
      <assert test="auc:OriginalOccupancyClassification">
        auc:OriginalOccupancyClassification is recommended for element: <name/>
      </assert>
    </rule>
  </pattern>

<!--
    Require that each auc:Section element is referenced to by exactly one of 
    each of the following elements via an @IDref:
    1. auc:Systems/auc:HVACSystems/auc:HVACSystem/auc:LinkedPremises/auc:Section/auc:LinkedSectionID
    2. auc:System/auc:LightingSystems/auc:LightingSystem/auc:LinkedPremises/auc:Section/auc:LinkedSectionID
    3. auc:System/auc:PlugLoads/auc:PlugLoad/auc:LinkedPremises/auc:Section/auc:LinkedSectionID
    <param> parent - an auc:Section element
-->
  <pattern abstract="true" id="sec.primarySystems">
    <rule context="$parent" role="error">
      <let name="sectionId" value="@ID"/>
      <let name="systemsElements" value="ancestor::auc:Facility/auc:Systems"/>
      <let name="hvacSystems" value="$systemsElements/auc:HVACSystems/auc:HVACSystem"/>
      <let name="hvacIDrefs" value="$hvacSystems//auc:LinkedSectionID/@IDref"/>
      <let name="idFromIdref" value="idref(@ID)"/>
      <let name="count" value="count(data($hvacIDrefs) = data($sectionId))"/>
      <let name="count2" value="count($hvacIDrefs = $sectionId)"/>
      <assert test="false()">
        <name/> has id: <value-of select="$sectionId"/>
      </assert>
      <assert test="false()">
        HVAC IDRefs: <value-of select="$hvacIDrefs"/>
      </assert>
      <assert test="false()">
        count: <value-of select="$count"/>.  count2: <value-of select="$count2"/>
      </assert>
      <assert test="false()">
        idFromIdref: <value-of select="$idFromIdref"/>
      </assert>
    </rule>
  </pattern>
  
</schema>