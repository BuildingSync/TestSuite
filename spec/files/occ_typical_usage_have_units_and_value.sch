<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/occupancyElements.sch#occ.typUsage.haveUnitsAndValue"/>
  <phase id="Tests">
    <active pattern="sec.occ.typUsage.haveUnitsAndValue"/>
  </phase>
  <pattern id="sec.occ.typUsage.haveUnitsAndValue" is-a="occ.typUsage.haveUnitsAndValue">
    <param name="parent" value="auc:Section/auc:TypicalOccupantUsages/auc:TypicalOccupantUsage"/>
  </pattern>
</schema>
