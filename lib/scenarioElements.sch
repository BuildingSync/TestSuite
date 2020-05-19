<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt1">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
<!--  
    For logic that pertains to Scenario elements
-->
  
<!--
    A baseline scenario must be defined.  Within the baseline scenario, the following 
    must be defined exactly: auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase IDref='Baseline'
-->
  <pattern id="sc.baseline">
    <let name="baselineCount" value="count(//auc:Scenario[@ID='Baseline'])"/>
    <rule context="auc:Scenarios">
      <assert test="$baselineCount = 1">
        There must be exactly one auc:Scenario with an attribute ID='Baseline' for <name/>
      </assert>
    </rule>
    <rule context="auc:Scenario[@ID='Baseline']">
      <assert test="auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref = 'Baseline'">
        For <name/>[@ID='Baseline'] the following subelements are required:
          auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase IDref='Baseline'
      </assert>
    </rule>
  </pattern>
  
</schema>