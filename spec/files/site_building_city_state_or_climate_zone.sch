<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/siteBuildingElements.sch#sbe.cityStateOrClimateZone"/>
  <phase id="Tests">
    <active pattern="sbe.sbe.cityStateOrClimateZone"/>
  </phase>
  <pattern id="sbe.sbe.cityStateOrClimateZone" is-a="sbe.cityStateOrClimateZone">
    <param name="parent" value="auc:Sites/auc:Site"/>
  </pattern>
</schema>
