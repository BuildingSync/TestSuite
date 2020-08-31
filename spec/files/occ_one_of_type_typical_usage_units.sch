<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/occupancyElements.sch#occ.oneOfType.typicalUsageUnits"/>
  <phase id="Tests">
    <active pattern="sec.occ.oneOfType.hoursPerWeek"/>
  </phase>
  <pattern id="sec.occ.oneOfType.hoursPerWeek" is-a="occ.oneOfType.typicalUsageUnits">
    <param name="parent" value="auc:Section/auc:TypicalOccupantUsages"/>
    <param name="typUsageUnits" value="'Hours per week'"/>
  </pattern>
</schema>
