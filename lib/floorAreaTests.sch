<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <ns prefix="auc" uri="http://buildingsync.net/schemas/bedes-auc/2019"/>
<!--  
    For logic pertaining to FloorArea elements.  Parent passed should be auc:FloorAreas,
    context can be anywhere ref="auc:FloorAreas"
-->
  
  <!--  Check that all auc:FloorArea elements have the auc:FloorAreaType and auc:FloorAreaValue -->
  <pattern abstract="true" id="fa.haveTypeAndValue">
    <rule context="$parent">
      <assert test="auc:FloorArea/auc:FloorAreaType and auc:FloorArea/auc:FloorAreaValue">
        auc:FloorArea elements must specify both a auc:FloorAreaType and auc:FloorAreaValue for <name/>
      </assert>
    </rule>
  </pattern>
  
<!--  Check that there is exactly one auc:FloorAreaType of Whatever -->
  <pattern abstract="true" id="fa.oneOfType">
    <rule context="$parent">
      <let name="areas" value="count(auc:FloorArea/auc:FloorAreaType[text() = $floorAreaType])"/>
      <assert test="$areas = 1">
        auc:FloorAreaType = <value-of select="$floorAreaType"/> must occur exactly once for <name/>.  Currently occurs: <value-of select="$areas"/>
      </assert>
    </rule>
  </pattern>
  
  <pattern abstract="true" id="fa.noneDefinedWarn">
    <rule context="$parent" role="warn">
      <let name="areas" value="count(auc:FloorArea/auc:FloorAreaType[text() = $floorAreaType])"/>
      <assert test="$areas != 0">
        auc:FloorAreaType = <value-of select="$floorAreaType"/> is not defined.  This is just a warning - element is not required./>
      </assert>
    </rule>
  </pattern>
  
  <pattern abstract="true" id="fa.mechTypeChecks">
    <rule context="$parent" role="error">
      <let name="grossArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Gross']) then (auc:FloorArea/auc:FloorAreaType[text()='Gross']/parent::auc:FloorArea/auc:FloorAreaValue) else (0.0)"/>
      <let name="cooledOnlyArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Cooled only']) then (auc:FloorArea/auc:FloorAreaType[text()='Cooled only']/parent::auc:FloorArea/auc:FloorAreaValue) else (0.0)"/>
      <let name="heatedOnlyArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Heated only']) then (auc:FloorArea/auc:FloorAreaType[text()='Heated only']/parent::auc:FloorArea/auc:FloorAreaValue) else (0.0)"/>
      <let name="heatedCooledArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']) then (auc:FloorArea/auc:FloorAreaType[text()='Heated and Cooled']/parent::auc:FloorArea/auc:FloorAreaValue) else (0.0)"/>
      <let name="ventilatedArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Ventilated']) then (auc:FloorArea/auc:FloorAreaType[text()='Ventilated']/parent::auc:FloorArea/auc:FloorAreaValue) else (0.0)"/>
      <let name="conditionedArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Conditioned']) then (auc:FloorArea/auc:FloorAreaType[text()='Conditioned']/parent::auc:FloorArea/auc:FloorAreaValue) else ($heatedOnlyArea + $cooledOnlyArea + $ventilatedArea + $heatedCooledArea)"/>
      <let name="unconditionedArea" value="if (auc:FloorArea/auc:FloorAreaType[text()='Unconditioned']) then (auc:FloorArea/auc:FloorAreaType[text()='Unconditioned']/parent::auc:FloorArea/auc:FloorAreaValue) else ($grossArea - $conditionedArea)"/>
      <assert test="$grossArea >= $cooledOnlyArea + $heatedOnlyArea + $heatedCooledArea + $ventilatedArea">
        Gross building Floor Area (<value-of select="$grossArea"/>) must be greater than or equal to: Heated and Cooled (<value-of select="$heatedCooledArea"/>) + Heated only (<value-of select="$heatedOnlyArea"/>) + Cooled only (<value-of select="$cooledOnlyArea"/>) + Ventilated (<value-of select="$ventilatedArea"/>)
      </assert>
      <assert test="$grossArea >= $conditionedArea + $unconditionedArea">
        Gross building Floor Area (<value-of select="$grossArea"/>) must be greater than or equal to: Conditioned (<value-of select="$conditionedArea"/>) + Unconditioned (<value-of select="$unconditionedArea"/>)
      </assert>
    </rule>
  </pattern>
</schema>