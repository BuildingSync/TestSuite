<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/occupancyElements.sch#occ.levels.haveQuantityAndType"/>
  <phase id="Tests">
    <active pattern="sec.occ.levels.haveQuantityAndType"/>
  </phase>

  <pattern id="sec.occ.levels.haveQuantityAndType" is-a="occ.levels.haveQuantityAndType">
    <param name="parent" value="auc:Section/auc:OccupancyLevels/auc:OccupancyLevel"/>
  </pattern>
</schema>