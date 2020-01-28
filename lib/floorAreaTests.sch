<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
<!--  
    For logic pertaining to FloorArea elements.  Parent passed should be auc:FloorAreas,
    context can be anywhere ref="auc:FloorAreas"
-->
  
  <!--  Check that all auc:FloorArea elements have the auc:FloorAreaType and auc:FloorAreaValue -->
  <pattern abstract="true" id="fa.haveTypeAndValue">
    <rule context="$parent">
      <assert test="auc:FloorArea/auc:FloorAreaType and auc:FloorArea/auc:FloorAreaValue">
        auc:FloorArea elements must specify both a auc:FloorAreaType and auc:FloorAreaValue for <name/>
      </assert>
    </rule>
  </pattern>
  
  <!--  Check that there is exactly one auc:FloorAreaType of Gross -->
  <pattern abstract="true" id="fa.oneGrossType">
    <rule context="$parent">
      <assert test="count(//auc:FloorAreaType[text()='Gross']) = 1">
        auc:FloorAreaType='Gross' must occur exactly once for <name/>
      </assert>
    </rule>
  </pattern>
</schema>