<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt1">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  
  <!--    
    This pattern ensures there is exactly one of every element inclusive of the Building element
    It walks the path: BuildingSync/Facilities/Facility/Sites/Site/Buildings/Building
  -->
  <pattern id="root.oneOfEachUntilBuilding">
    <rule context="/">
      <assert test="count(auc:BuildingSync) = 1"
        >element "auc:BuildingSync" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule context="auc:BuildingSync">
      <assert test="count(auc:Facilities) = 1"
        >element "auc:Facilities" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule context="auc:Facilities">
      <assert test="count(auc:Facility) = 1"
        >element "auc:Facility" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule context="auc:Facility">
      <assert test="count(auc:Sites) = 1"
        >element "auc:Sites" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule context="auc:Sites">
      <assert test="count(auc:Site) = 1"
        >element "auc:Site" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule context="auc:Site">
      <assert test="count(auc:Buildings) = 1"
        >element "auc:Buildings" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule
      context="auc:Buildings">
      <assert test="count(auc:Building) = 1"
        >element "auc:Building" is REQUIRED EXACTLY ONCE</assert>
    </rule>
  </pattern>
  
  <!--    
    This pattern ensures there is exactly one of every element inclusive of the Scenario element
    It starts at the Facility element and walks the path: Reports/Report/Scenarios/Scenario
  -->
  <pattern id="root.oneOfEachFacilityUntilScenario">
    <rule context="auc:Facility">
      <assert test="count(auc:Reports) = 1"
        >element "auc:Reports" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule context="auc:Reports">
      <assert test="count(auc:Report) >= 1"
        >element "auc:Report" is REQUIRED AT LEAST ONCE</assert>
    </rule>
    <rule context="auc:Report">
      <assert test="count(auc:Scenarios) = 1"
        >element "auc:Scenarios" is REQUIRED EXACTLY ONCE</assert>
    </rule>
    <rule context="auc:Scenarios">
      <assert test="count(auc:Scenario) >= 1"
        >element "auc:Scenario" is REQUIRED AT LEAST ONCE</assert>
    </rule>
  </pattern>
</schema>