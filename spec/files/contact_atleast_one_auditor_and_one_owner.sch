<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/contactElements.sch#con.atleastOneAuditorAndOneOwner"/>
  <phase id="Tests">
    <active pattern="con.con.atleastOneAuditorAndOneOwner"/>
  </phase>
  <pattern id="con.con.atleastOneAuditorAndOneOwner" is-a="con.atleastOneAuditorAndOneOwner">
    <param name="parent" value="auc:Facility/auc:Contacts"/>
  </pattern>
</schema>
