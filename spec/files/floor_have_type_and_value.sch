<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.haveTypeAndValue"/>
  <phase id="Tests">
    <active pattern="be.fa.haveTypeAndValue"/>
  </phase>
  <pattern id="be.fa.haveTypeAndValue" is-a="fa.haveTypeAndValue">
    <param name="parent" value="auc:Building/auc:FloorAreas/auc:FloorArea"/>
  </pattern>
</schema>
