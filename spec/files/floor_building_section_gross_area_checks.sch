<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.buildingSectionGrossAreaChecks"/>
  <phase id="Tests">
    <active pattern="all.fa.buildingSectionGrossAreaChecks"/>
  </phase>
  <pattern id="all.fa.buildingSectionGrossAreaChecks" is-a="fa.buildingSectionGrossAreaChecks">
    <param name="parent" value="auc:Buildings/auc:Building"/>
  </pattern>
</schema>
