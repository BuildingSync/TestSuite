<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/sectionElements.sch#sec.mainDetails"/>
  <phase id="Tests">
    <active pattern="sec.sec.mainDetails"/>
  </phase>
  <pattern id="sec.sec.mainDetails" is-a="sec.mainDetails">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']"/>
  </pattern>
</schema>
