<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.type.valueOrPercent"/>
  <phase id="Tests">
    <active pattern="all.fa.type.valueOrPercent"/>
  </phase>
  <pattern id="all.fa.type.valueOrPercent" is-a="fa.type.valueOrPercent">
    <param name="parent" value="auc:FloorAreas/auc:FloorArea"/>
  </pattern>
</schema>
