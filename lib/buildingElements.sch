<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
<!--  For logic pertaining to a Building element. -->
  
  <!--    Required elements for L000 at the building level -->
  <pattern id="be.L000">
    <rule context="auc:Building">
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
</schema>