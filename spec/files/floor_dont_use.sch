<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.dontUse"/>
  <phase id="Tests">
    <active pattern="all.fa.dontUse"/>
  </phase>
  <pattern id="all.fa.dontUse" is-a="fa.dontUse">
    <param name="parent" value="auc:FloorAreas"/>
  </pattern>
</schema>
