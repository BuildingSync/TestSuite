# Schematron
The TestSuite is designed to allow developers to reuse BuildingSync logic for their own specific use case.  The `lib/` directory provides modular Schematron functions such that they can be used in larger Schematron use case files.  The [BuildingSync_schematron_L000.sch](https://github.com/BuildingSync/TestSuite/blob/master/tests/schema2.0.0-pr2/Level_000/BuildingSync_schematron_L000.sch) and [BuildingSync_schematron_L100.sch](https://github.com/BuildingSync/TestSuite/blob/L100_Schematron/tests/schema2.0.0-pr2/Level_100/BuildingSync_schematron_L100.sch) files are good examples of how this can be done.

## Limitations with schematron-nokogiri Ruby Library
- Uses XPath 1.0, so be careful when developing new functions to make sure they only use XPath 1.0 expressions
- Does not differentiate between different [Schematron severity levels](http://schematron.com/2018/12/standard-severity-levels-with-schematron-role/).  Everything from Schematron's perspective is viewed as an error.  To compensate for this, the authors use `[ERROR]`, `[WARNING]`, and `[INFO]` prepended to Schematron messages to help users understand the severity of the report / assertion (see [Standard Error Messages](#standard-error-messages))

## Adding Generic Schematron Functions

The following is an example Schematron function for Floor Areas.
```xml
<!--  
    Check that all auc:FloorArea elements have the auc:FloorAreaType and auc:FloorAreaValue.
    <severity> error
    <param> parent - an auc:FloorAreas element
-->
  <pattern abstract="true" id="fa.haveTypeAndValue">
    <rule context="$parent">
      <assert test="auc:FloorArea/auc:FloorAreaType and auc:FloorArea/auc:FloorAreaValue">
        [ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for element 'auc:FloorArea' within: '<name/>'
      </assert>
    </rule>
  </pattern>
```

All new functions should provide structured comments as above defining severities and parameters (for abstract function declarations).

### Standard Error Messages
The following are provided as example error messages.  General rules:
- Wrap BuildingSync elements in single quotes in messages ('auc:Facility')
- Place the logging level at the beginning of the assertion in all caps surrounded by brackets (<assert>[LOG LEVEL])
- For `[ERROR]` logs, use keywords like REQUIRED or MUST HAVE
- For `[WARNING]` logs, use keywords like RECOMMENDED

Examples provided below:
```xml
<assert>[ERROR] element '' is REQUIRED EXACTLY ONCE for: '<name/>'</assert>
<assert>[ERROR] element '' is REQUIRED AT LEAST ONCE for: '<name/>'</assert>
<assert>[WARNING] element '' is RECOMMENDED for: '<name/>’</assert>
<assert>[ERROR] elements '' and '' are REQUIRED EXACTLY ONCE within element '' for: '<name/>'</assert>
<assert>[ERROR] element '' MUST HAVE VALUE '<value-of select=“"/>' for '<name/>'</assert>
```

# Contributions

1. Make a new branch with pattern: `feature-[yourFunction]`
1. Add a [proposal](../proposals/README.md)
1. Push the new branch to Github for proposal review
1. Develop the Schematron function
1. Make a new spec file with pattern `spec/lib/[your_group_of_functions]_spec.rb`
1. Make a new Schematron file in `spec/files/[your_function].sch` that simply imports the newly developed Schematron function into a new phase or pattern (so as to solely isolate an individual function).  See other examples for specifics.
1. Create a new XML file (or use an existing one) in `spec/files/good` which will be used as the root for testing
1. Add tests.  When all tests are passing, create a pull request