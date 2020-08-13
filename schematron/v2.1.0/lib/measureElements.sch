<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
<!--  
  Define measure elements required for successful roundtrip of scenarios through ATT -->
  <sch:pattern id="ms.seedATT.reqs">
    <sch:rule context="/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure">
      <sch:assert test="count(.) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/" is REQUIRED</sch:assert>
      <sch:assert test="count(./auc:TechnologyCategories/auc:TechnologyCategory/*[1]) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/*[1]" is REQUIRED</sch:assert>
      <sch:assert test="count(./auc:TechnologyCategories/auc:TechnologyCategory/*[1]//auc:MeasureName) = 1">
        [ERROR] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:TechnologyCategories/auc:TechnologyCategory/*[1]//auc:MeasureName" is REQUIRED</sch:assert>
      <sch:assert test="count(./auc:ImplementationStatus) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:ImplementationStatus" is RECOMMENDED</sch:assert>
      <sch:assert test="count(./auc:MeasureScaleOfApplication) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:MeasureScaleOfApplication" is RECOMMENDED</sch:assert>
      <sch:assert test="count(./auc:SystemCategoryAffected) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:SystemCategoryAffected" is RECOMMENDED</sch:assert>
      <sch:assert test="count(./auc:Recommended) = 1">
        [WARNING] element "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Measures/auc:Measure/auc:Recommended" is RECOMMENDED</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>