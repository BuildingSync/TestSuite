<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.oneOfMechType"/>
  <phase id="Tests">
    <active pattern="all.fa.oneOfMechType"/>
  </phase>
  <pattern id="all.fa.oneOfMechType" is-a="fa.oneOfMechType">
    <param name="parent" value="auc:FloorAreas"/>
  </pattern>
</schema>
