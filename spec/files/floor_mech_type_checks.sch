<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.mechTypeChecks"/>
  <phase id="Tests">
    <active pattern="be.fa.mechTypeChecks"/>
  </phase>
  <pattern id="be.fa.mechTypeChecks" is-a="fa.mechTypeChecks">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
  </pattern>
</schema>
