<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
<!--  
    For logic pertaining to FloorArea elements.
-->
  
<!--  
    Each FloorAreaType enumeration can occur AT MOST one time in a set of FloorArea elements.
    <param> parent - an auc:FloorAreas element
-->
  <pattern abstract="true" id="fa.maxOneOfEachType">
    <rule context="$parent" role="fatal">
      <let name="tenant" value="count(auc:FloorArea[auc:FloorAreaType = 'Tenant'])"/>
      <let name="common" value="count(auc:FloorArea[auc:FloorAreaType = 'Common'])"/>
      <let name="gross" value="count(auc:FloorArea[auc:FloorAreaType = 'Gross'])"/>
      <let name="net" value="count(auc:FloorArea[auc:FloorAreaType = 'Net'])"/>
      <let name="finished" value="count(auc:FloorArea[auc:FloorAreaType = 'Finished'])"/>
      <let name="footprint" value="count(auc:FloorArea[auc:FloorAreaType = 'Footprint'])"/>
      <let name="rentable" value="count(auc:FloorArea[auc:FloorAreaType = 'Rentable'])"/>
      <let name="occupied" value="count(auc:FloorArea[auc:FloorAreaType = 'Occupied'])"/>
      <let name="lighted" value="count(auc:FloorArea[auc:FloorAreaType = 'Lighted'])"/>
      <let name="daylit" value="count(auc:FloorArea[auc:FloorAreaType = 'Daylit'])"/>
      <let name="heated" value="count(auc:FloorArea[auc:FloorAreaType = 'Heated'])"/>
      <let name="cooled" value="count(auc:FloorArea[auc:FloorAreaType = 'Cooled'])"/>
      <let name="conditioned" value="count(auc:FloorArea[auc:FloorAreaType = 'Conditioned'])"/>
      <let name="unconditioned" value="count(auc:FloorArea[auc:FloorAreaType = 'Unconditioned'])"/>
      <let name="semiConditioned" value="count(auc:FloorArea[auc:FloorAreaType = 'Semi-conditioned'])"/>
      <let name="heatedCooled" value="count(auc:FloorArea[auc:FloorAreaType = 'Heated and Cooled'])"/>
      <let name="heatedOnly" value="count(auc:FloorArea[auc:FloorAreaType = 'Heated only'])"/>
      <let name="cooledOnly" value="count(auc:FloorArea[auc:FloorAreaType = 'Cooled only'])"/>
      <let name="ventilated" value="count(auc:FloorArea[auc:FloorAreaType = 'Ventilated'])"/>
      <let name="enclosed" value="count(auc:FloorArea[auc:FloorAreaType = 'Enclosed'])"/>
      <let name="nonEnclosed" value="count(auc:FloorArea[auc:FloorAreaType = 'Non-Enclosed'])"/>
      <let name="open" value="count(auc:FloorArea[auc:FloorAreaType = 'Open'])"/>
      <let name="lot" value="count(auc:FloorArea[auc:FloorAreaType = 'Lot'])"/>
      <let name="custom" value="count(auc:FloorArea[auc:FloorAreaType = 'Custom'])"/>
      <assert test="1 >= $tenant">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Tenant'
      </assert>
      <assert test="1 >= $common">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Common'
      </assert>
      <assert test="1 >= $gross">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Gross'
      </assert>
      <assert test="1 >= $net">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Net'
      </assert>
      <assert test="1 >= $finished">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Finished'
      </assert>
      <assert test="1 >= $footprint">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Footprint'
      </assert>
      <assert test="1 >= $rentable">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Rentable'
      </assert>
      <assert test="1 >= $occupied">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Occupied'
      </assert>
      <assert test="1 >= $lighted">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Lighted'
      </assert>
      <assert test="1 >= $daylit">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Daylit'
      </assert>
      <assert test="1 >= $heated">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Heated'
      </assert>
      <assert test="1 >= $cooled">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Cooled'
      </assert>
      <assert test="1 >= $conditioned">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Conditioned'
      </assert>
      <assert test="1 >= $unconditioned">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Unconditioned'
      </assert>
      <assert test="1 >= $semiConditioned">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Semi-conditioned'
      </assert>
      <assert test="1 >= $heatedCooled">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Heated and Cooled'
      </assert>
      <assert test="1 >= $heatedOnly">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Heated only'
      </assert>
      <assert test="1 >= $cooledOnly">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Cooled only'
      </assert>
      <assert test="1 >= $ventilated">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Ventilated'
      </assert>
      <assert test="1 >= $enclosed">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Enclosed'
      </assert>
      <assert test="1 >= $nonEnclosed">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Non-Enclosed'
      </assert>
      <assert test="1 >= $open">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Open'
      </assert>
      <assert test="1 >= $lot">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Lot'
      </assert>
      <assert test="1 >= $custom">
        An auc:FloorAreas element should contain at most one auc:FloorAreaType = 'Custom'
      </assert>
    </rule>
  </pattern>
  
<!--  
    Check that all auc:FloorArea elements have the auc:FloorAreaType and auc:FloorAreaValue.
    <severity> error
    <param> parent - an auc:FloorAreas element
-->
  <pattern abstract="true" id="fa.haveTypeAndValue">
    <rule context="$parent">
      <assert test="auc:FloorArea/auc:FloorAreaType and auc:FloorArea/auc:FloorAreaValue">
        auc:FloorArea elements must specify both a auc:FloorAreaType and auc:FloorAreaValue for <name/>
      </assert>
    </rule>
  </pattern>
  
<!--  
    Check that there is exactly one auc:FloorAreaType
    <severity> error
    <param> parent - an auc:FloorAreas element
    <param> floorAreaType - one of the standardized string enumerations of the auc:FloorAreaType element
-->
  <pattern abstract="true" id="fa.oneOfType">
    <rule context="$parent" role="fatal">
      <let name="areas" value="count(auc:FloorArea[auc:FloorAreaType = $floorAreaType])"/>
      <assert test="$areas = 1">\
        auc:FloorAreaType = <value-of select="$floorAreaType"/> must occur exactly once for <name/>.  Currently occurs: <value-of select="$areas"/>
      </assert>
    </rule>
  </pattern>

<!--  
    Check if an auc:FloorAreaType is declared.
    <severity> warn
    <param> parent - an auc:FloorAreas element
    <param> floorAreaType - one of the standardized string enumerations of the auc:FloorAreaType element
-->
  <pattern abstract="true" id="fa.noneDefinedWarn">
    <rule context="$parent" role="warn">
      <let name="areas" value="count(auc:FloorArea/auc:FloorAreaType[text() = $floorAreaType])"/>
      <assert test="$areas != 0">
        auc:FloorAreaType = <value-of select="$floorAreaType"/> is not defined - did you mean to define it?  If not, this is just a warning - element is not required./>
      </assert>
    </rule>
  </pattern>

<!--
    Check mechanical floor area types add up to the gross type.  The following values are assumed if the type is not declared, 
    although these types are not inserted in the BSync document:
    - Cooled only -> 0.0
    - Heated only -> 0.0
    - Heated and Cooled -> 0.0
    - Ventilated -> 0.0
    - Conditioned -> Cooled only + Heated only + Heated and Cooled + Ventilated
    - Unconditioned -> Gross - Conditioned
    <severity> error
    <param> parent - an auc:FloorAreas element
-->
  <pattern abstract="true" id="fa.mechTypeChecks">
    <rule context="$parent" role="error">
      <let name="grossArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Gross']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Gross']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="cooledOnlyArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Cooled only']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Cooled only']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="heatedOnlyArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Heated only']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Heated only']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="heatedCooledArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="ventilatedArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Ventilated']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Ventilated']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="conditionedArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Conditioned']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Conditioned']/parent::auc:FloorArea/auc:FloorAreaValue)) else ($heatedOnlyArea + $cooledOnlyArea + $ventilatedArea + $heatedCooledArea)"/>
      <let name="unconditionedArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Unconditioned']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Unconditioned']/parent::auc:FloorArea/auc:FloorAreaValue)) else ($grossArea - $conditionedArea)"/>
      <assert test="$grossArea >= $cooledOnlyArea + $heatedOnlyArea + $heatedCooledArea + $ventilatedArea">
        Gross building Floor Area (<value-of select="$grossArea"/>) must be greater than or equal to: Heated and Cooled (<value-of select="$heatedCooledArea"/>) + Heated only (<value-of select="$heatedOnlyArea"/>) + Cooled only (<value-of select="$cooledOnlyArea"/>) + Ventilated (<value-of select="$ventilatedArea"/>)
      </assert>
      <assert test="$grossArea >= $conditionedArea + $unconditionedArea">
        Gross building Floor Area (<value-of select="$grossArea"/>) must be greater than or equal to: Conditioned (<value-of select="$conditionedArea"/>) + Unconditioned (<value-of select="$unconditionedArea"/>)
      </assert>
    </rule>
  </pattern>
  
<!--  
    Check that 'Heated' and 'Cooled' FloorAreaTypes are not defined.
    <severity> error
    <param> parent - an auc:FloorAreas element
-->
  <pattern abstract="true" id="fa.dontUse">
    <rule context="$parent">
      <assert test="not (auc:FloorArea/auc:FloorAreaType[text()='Heated'])">
        auc:FloorAreatype of 'Heated' should not be used.
      </assert>
      <assert test="not (auc:FloorArea/auc:FloorAreaType[text()='Cooled'])">
        auc:FloorAreatype of 'Cooled' should not be used.
      </assert>
    </rule>
  </pattern>

<!--  
    Check that at least one of the mechanical floor area types is defined.
    <severity> error
    <param> parent - an auc:FloorAreas element
-->
  <pattern abstract="true" id="fa.oneOfMechType">
    <rule context="$parent">
      <assert test="auc:FloorArea/auc:FloorAreaType[text()='Conditioned'] or 
                    auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled'] or
                    auc:FloorArea/auc:FloorAreaType[text()='Heated only'] or
                    auc:FloorArea/auc:FloorAreaType[text()='Cooled only'] or
                    auc:FloorArea/auc:FloorAreaType[text()='Ventilated']">
        One of the following Floor Area typs must be defined: Conditioned, Heated and Cooled, Heated only, Cooled only, Ventilated
      </assert>
    </rule>
  </pattern>
  
<!--  
    Check that the Conditioned area is greater than Cooled only + Heated only + Heated and Cooled + Ventilated
    <severity> error
    <param> parent - an auc:FloorArea[auc:FloorAreaType='Conditioned' and auc:FloorAreaPercentage] element
-->  
  <pattern abstract="true" id="fa.conditionedPercentChecks">
    <rule context="$parent">
      <let name="grossArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Gross']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Gross']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="cooledOnlyArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Cooled only']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Cooled only']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="heatedOnlyArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated only']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated only']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="heatedCooledArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="ventilatedArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Ventilated']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Ventilated']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="conditionedAreaPercentage" value="auc:FloorAreaPercentage"/>
      <let name="conditionedAreaValue" value="$grossArea*$conditionedAreaPercentage div 100"/>
      <assert test="$conditionedAreaValue >= $cooledOnlyArea + $heatedOnlyArea + $heatedCooledArea + $ventilatedArea">
        Conditioned Area Percentage * Gross Area (<value-of select="$conditionedAreaValue"/>) must be greater than or equal to: Heated and Cooled (<value-of select="$heatedCooledArea"/>) + Heated only (<value-of select="$heatedOnlyArea"/>) + Cooled only (<value-of select="$cooledOnlyArea"/>) + Ventilated (<value-of select="$ventilatedArea"/>)
      </assert>
    </rule>
  </pattern>

<!--  
    Check that the Gross area is greater than or equal to the Conditioned area.
    Check that the Conditioned area is greater than Cooled only + Heated only + Heated and Cooled + Ventilated
    <severity> error
    <param> parent - an auc:FloorArea[auc:FloorAreaType='Conditioned' and auc:FloorAreaValue] element
-->  
  <pattern abstract="true" id="fa.conditionedValueChecks">
    <rule context="$parent">
      <let name="grossArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Gross']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Gross']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="cooledOnlyArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Cooled only']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Cooled only']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="heatedOnlyArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated only']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated only']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="heatedCooledArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']) then (number(parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="ventilatedArea" value="if (parent::node()/auc:FloorArea/auc:FloorAreaType[text()='Ventilated']) then (number(auc:FloorArea/auc:FloorAreaType[text()='Ventilated']/parent::auc:FloorArea/auc:FloorAreaValue)) else (0.0)"/>
      <let name="conditionedAreaValue" value="number(auc:FloorAreaValue/text())"/>
      <assert test="false()">
        JUST PRINT VALUES: Gross Area (<value-of select="$grossArea"/>) must be greater than or equal to Conditioned Area Value (<value-of select="$conditionedAreaValue"/>)
      </assert>
      <assert test="$grossArea >= $conditionedAreaValue">
        Gross Area (<value-of select="$grossArea"/>) must be greater than or equal to Conditioned Area Value (<value-of select="$conditionedAreaValue"/>)
      </assert>
      <assert test="$conditionedAreaValue >= $cooledOnlyArea + $heatedOnlyArea + $heatedCooledArea + $ventilatedArea">
        Conditioned Area Value (<value-of select="$conditionedAreaValue"/>) must be greater than or equal to: Heated and Cooled (<value-of select="$heatedCooledArea"/>) + Heated only (<value-of select="$heatedOnlyArea"/>) + Cooled only (<value-of select="$cooledOnlyArea"/>) + Ventilated (<value-of select="$ventilatedArea"/>)
      </assert>
    </rule>
  </pattern>
</schema>