# Overview

`app.rb` is used to generate the `BuildingSync_schematron.rb` file.  It works by traversing an XSD file over all elements in the provided `TOP_LEVEL_ELEMENT`.  It permits all XSD elements specified:
```
bundle exec ruby ./app.rb XSD_FILE NAMESPACE_PREFIX TOP_LEVEL_ELEMENT
bundle exec ruby ./app.rb BuildingSync.xsd auc BuildingSync
``` 

In order to then generate an schematron XML document based on the given XSD:
```
bundle exec ruby ./BuildingSync_schematron.rb
```

The file name to write each of the above two files out can be changed in the scripts themselves.

# Tests

The tests folder contains similar code used to generate schematron XML documents, based on the requirements of the different levels.

# Usage

TODO: Run test for different levels
```
bundle exec rake L100_test
```

TODO: Generate schematron doc for given 'level'
```
bundle exec rake gen_sch L100
```