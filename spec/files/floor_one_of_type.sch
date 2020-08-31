<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/floorElements.sch#fa.oneOfType"/>
  <phase id="Tests">
    <active pattern="gross.fa.oneOfType"/>
    <active pattern="cool.fa.oneOfType"/>
    <active pattern="heatCool.fa.oneOfType"/>
    <active pattern="heat.fa.oneOfType"/>
  </phase>
  <pattern id="gross.fa.oneOfType" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Gross'"/>
  </pattern>
  <pattern id="cool.fa.oneOfType" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Cooled only'"/>
  </pattern>
  <pattern id="heatCool.fa.oneOfType" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Heated and Cooled'"/>
  </pattern>
  <pattern id="heat.fa.oneOfType" is-a="fa.oneOfType">
    <param name="parent" value="auc:Building/auc:FloorAreas"/>
    <param name="floorAreaType" value="'Heated only'"/>
  </pattern>
</schema>
