<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
<!--  
    For logic pertaining to Contact elements.  Parent passed should be an auc:Contact.
-->
  
<!--  
    Check that the name, email, and phone number are specified for contacts.
    <severity> error
    <param> parent - an auc:Contact element
-->
  <pattern abstract="true" id="con.nameEmailPhone">
    <rule context="$parent">
      <assert test="auc:ContactName">
        auc:ContactName must be specified for element: <name/>
      </assert>
      <assert test="count(auc:ContactEmailAddresses//auc:EmailAddress[text()]) >= 1">
        auc:EmailAddress must be specified for element: <name/>
      </assert>
      <assert test="count(auc:ContactTelephoneNumbers//auc:TelephoneNumber[text()]) >= 1">
        auc:TelephoneNumber must be specified for element: <name/>
      </assert>
    </rule>
  </pattern>
  
</schema>