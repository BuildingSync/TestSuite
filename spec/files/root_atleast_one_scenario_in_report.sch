<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/rootElements.sch#root.atleastOneScenarioInReport"/>
  <phase id="Tests">
    <active pattern="root.atleastOneScenarioInReport"/>
  </phase>
</schema>