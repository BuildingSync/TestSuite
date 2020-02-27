<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
  <include href="../../lib/contactElements.sch#con.nameEmailPhone"/>
  <phase id="Tests">
    <active pattern="con.con.nameEmailPhone"/>
  </phase>
  <pattern id="con.con.nameEmailPhone" is-a="con.nameEmailPhone">
    <param name="parent" value="auc:Contacts/auc:Contact"/>
  </pattern>
</schema>
