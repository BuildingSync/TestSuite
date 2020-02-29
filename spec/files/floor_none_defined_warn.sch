<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.noneDefinedWarn"/>
  <phase id="Tests">
    <active pattern="all.fa.noneDefinedWarn"/>
  </phase>
  <pattern id="all.fa.noneDefinedWarn" is-a="fa.noneDefinedWarn">
    <param name="parent" value="auc:FloorAreas"/>
    <param name="floorAreaType" value="'Ventilated'"/>
  </pattern>
</schema>
