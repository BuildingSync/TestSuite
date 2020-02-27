<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/occupancyElements.sch#occ.levels.oneOfType"/>
  <phase id="Tests">
    <active pattern="sec.occ.levels.oneOfType"/>
  </phase>
  <pattern id="sec.occ.levels.oneOfType" is-a="occ.levels.oneOfType">
    <param name="parent" value="auc:Section/auc:OccupancyLevels"/>
    <param name="occLevelType" value="'Peak total occupants'"/>
  </pattern>
</schema>
