# Schematron Function or Use Cases Proposal
The proposer writes a Markdown document, with the required sections as specified below, that succinctly describes the changes that are proposed.

## Required for Functions
Add the following sections:
1. Function Purpose
1. Expected Function Behavior
1. Function Tests

# Function Purpose
Describe what the need for the function is. For example: I need a function to check that every `auc:FloorArea` element within an `auc:FloorAreas` context that has an `auc:FloorAreaType` and `auc:FloorAreaValue` child elements specified.  It will be an abstract function.

# Expected Function Behavior
Define what severity level output is expected and general element structure required for the context to be found and the rule to fire.  For example: The function will produce an `[ERROR]` if each `auc:FloorArea` element does not look like:
```xml
<auc:FloorArea>
  <auc:FloorAreaType></auc:FloorAreaType>
  <auc:FloorAreaValue></auc:FloorAreaValue>
  ...other elements ok...
</auc:FloorArea>
```

# Function Tests
Briefly describe the tests to be implemented.  It should include tests for both proper and improper behavior.  For example:
- Proper Behavior
    - Should not fail given `test-file.xml`
    - Should not fail if other child elements specified under a `auc:FloorArea` element
- Improper Behavior
    - Should fail if `auc:FloorAreaType` is not present
    - Should fail if `auc:FloorAreaValue` is not present
    - Should fail if both are not present
    - Should fail for each `auc:FloorArea` element within an `auc:FloorAreas` element where the above conditions are not met

The best way we have found to implement tests is to start off with a Proper representation in the `test-file.xml`, then manipulate it in memory using Nokogiri and then test it against Schematron.  This helps minimize the number of XML files created for testing.