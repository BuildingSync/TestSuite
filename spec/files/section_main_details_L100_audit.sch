<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/sectionElements.sch#sec.mainDetails.L100.audit"/>
  <phase id="Tests">
    <active pattern="sec.sec.mainDetails.L100.audit"/>
  </phase>
  <pattern id="sec.sec.mainDetails.L100.audit" is-a="sec.mainDetails.L100.audit">
    <param name="parent" value="auc:Section[auc:SectionType='Space function']"/>
  </pattern>
</schema>
