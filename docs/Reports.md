# Reports: Energy - Resources - Utilities
This document provides information regarding the structure of Reports and their role in communicating information about resources consumed by the building, utilities serving the building, and time series data for the building.

## Introduction
It is important to understand the schema hierarchy when modeling these concepts.  Most importantly:
- Resources are defined on a Scenario basis as follows: `auc:Report/auc:Scenarios/auc:Scenario/auc:ResourceUses/auc:ResourceUse`.  
- Utilities are defined on a Report basis as follows: `auc:Report/auc:Utilities/auc:Utility`.

# Standard 211 Requirements
Modeling concepts that are important for Standard 211 specifically.

## Reports and Scenarios
To represent historical data for the Building (Std 211 Section 6.1.2), the `auc:Report/auc:Scenarios/auc:Scenario` element is used.

### Historical Energy Use (6.1.2)
Exactly one Scenario will be created to represent the Monthly and Annual Utility Data.  The following characteristics are required:
- Denote the type of scenario as follows (the ID and Name don't have to be the same, just provided as reference):
```xml
            <auc:Scenario ID="Measured">
            <auc:ScenarioName>Measured Data</auc:ScenarioName>
            <auc:ScenarioType>
              <auc:CurrentBuilding>
                <auc:CalculationMethod>
                  <auc:Measured>
                    <auc:MeasuredEnergySource>
                    </auc:MeasuredEnergySource>
                  </auc:Measured>
                </auc:CalculationMethod>
              </auc:CurrentBuilding>
            </auc:ScenarioType>
          </auc:Scenario>
```
- The `auc:MeasuredEnergySource` should be further defined via one of its options:
    - `auc:UtilityBills` 
    - `auc:DirectMeasurement` (6.1.2.1.d)
    - `auc:Other`

#### Resources
- An `auc:ResourceUse` should be created for every metered substance (fuel, water, etc.) which is included in the audit
- The resource should be further characterized as either an `auc:ResourceUse/auc:EnergyResource` or `auc:ResourceUse/auc:WaterResource`.
- Units MUST be defined for the resource via `auc:ResourceUse/auc:ResourceUnits`.  This is what is referred to as the 'Native' units of the resource (TODO is this true?)
- Every resource must be associated with at least one utility via the `IDref` attribute of an `auc:ResourceUse/auc:UtilityIDs/auc:UtilityID`.

#### Utilities
- An `auc:Utility` MUST be defined for all entities providing resources to the building (6.1.2.1.a)
- The following fields MUST be defined for the `auc:Utility` (6.1.2.1.b):
    - `auc:UtilityName`
    - `auc:UtilityAccountNumber`
    - `auc:MeteringConfiguration` - TODO - at this point in time, regardless of potentially different resources being fed by a single Utility entity, the metering configuration must be defined at the Utility level.  This prohibits the potential that (for example) Electricity and Natural Gas delivered by the same Utility have different metering configurations for each of the resources.  
    - At least one `auc:RateSchedules/auc:RateSchedule` with the `auc:RateStructureName` and `auc:TypeOfRateStructure` child elements defined (6.1.2.1.c)

#### Monthly and Annual Energy Data
__Note - see also [TimeSeries Data](#timeseries-data)__

Supposing 

### Section 6.1.2.2
A different Scenario will be created to represent the Benchmark.  The following characteristics are required:
- Denote the type of scenario as follows:
```xml
            <auc:Scenario ID="Benchmark">
              <auc:ScenarioName>Benchmark</auc:ScenarioName>
              <auc:ScenarioType>
                <auc:Benchmark>
                  <auc:BenchmarkYear>2016</auc:BenchmarkYear>
                  <auc:BenchmarkType>
                  </auc:BenchmarkType>
                  <auc:BenchmarkValue>[value]</auc:BenchmarkValue>
                  <auc:LinkedPremises>
                    <auc:Building>
                      <auc:LinkedBuildingID IDref="BuildingID-of-interest"></auc:LinkedBuildingID>
                    </auc:Building>
                  </auc:LinkedPremises>
                </auc:Benchmark>
              </auc:ScenarioType>
            </auc:Scenario>
```
Within the `auc:BenchmarkType` field, define one of the child elements as applicable to define the source of the benchmarking information.  The following examples are provided:

__CBECS__
Define a CBECS benchmark from the 2018 survey for ClimateZone 5, where the reference EUI was 52:
```xml
              <auc:ScenarioType>
                <auc:Benchmark>
                  <auc:BenchmarkYear>2018</auc:BenchmarkYear>
                  <auc:BenchmarkValue>52</auc:BenchmarkValue>
                  <auc:BenchmarkType>
                    <auc:CBECS>
                      <auc:ClimateZone>5</auc:ClimateZone>
                    </auc:CBECS>
                  </auc:BenchmarkType>
                  ...
                </auc:Benchmark>
              </auc:ScenarioType>
```

__PortfilioManager__
Define a Portfolio Manager benchmark ... TODO - how to use?

__CodeMinimum__
Define a code minimum benchmark ... TODO - how to use?

__StandardPractice__
Define a standard practice benchmark  ... TODO - how to use?

# TimeSeries Data
TimeSeries data is created as follows:
- After an `auc:ResourceUse` is declared, time series data can be included via the `auc:Scenario/auc:TimeSeriesData/auc:TimeSeries` element.
- An `auc:TimeSeries` element is created for every data reading to be captured.  For example, 12 months of Electricity data would require 12 `auc:TimeSeries` elements, one for each month.  The general structure of this element is as follows:
```xml
                <auc:TimeSeries ID="TimeSeriesType-70103180699520">
                  <auc:ReadingType>Point</auc:ReadingType>
                  <auc:TimeSeriesReadingQuantity>Energy</auc:TimeSeriesReadingQuantity>
                  <auc:StartTimestamp>2016-01-01T00:00:00+00:00</auc:StartTimestamp>
                  <auc:EndTimestamp>2016-02-01T00:00:00+00:00</auc:EndTimestamp>
                  <auc:IntervalFrequency></auc:IntervalFrequency>
                  <auc:IntervalReading>1234</auc:IntervalReading>
                  <auc:ResourceUseID IDref="ResourceUseType-70103182353720"></auc:ResourceUseID>
                </auc:TimeSeries>
```
When modeling time series data, the following notions should be observed:
- If an `auc:ResourceUse` exists for the reading, the `auc:TimeSeries/auc:ResourceUseID/@IDref` attribute should point to the `ID` attribute of that Resource.
- The units associated with the `auc:IntervalReading` are defined by the `auc:Resource/auc:ResourceUnits`, which is why the `auc:ResourceUnits` element is required for an `auc:Resource` element

## Timestamps and Intervals
- Only two of the three following elements need be defined:
    - `auc:StartTimestamp`, `auc:EndTimestamp`, `auc:IntervalFrequency`
- Given two of the three, the third can be inferred:
    - `auc:StartTimestamp`, `auc:EndTimestamp`:
        - Although no interval frequency is really necessary, given that the `auc:IntervalFrequency` must take on one of the following enums if declared, the following logic can be applied to determine the value of `auc:IntervalFrequency`:
            - `1 minute` - timedelta(start - end) = 60 seconds
            - `5 minute` - timedelta(start - end) = 300 seconds
            - `10 minute` - timedelta(start - end) = 600 seconds
            - `15 minute` - timedelta(start - end) = 900 seconds
            - `30 minute` - timedelta(start - end) = 1800 seconds
            - `Hour` - timedelta(start - end) = 3600 seconds
            - `Day` -  timedelta(start - end) = 24 hours
            - `Week` - timedelta(start - end) = 168 hours
            - `Month` - 28 days <= timedelta(start - end) <= 31 days
            - `Quarter` - timedelta(start - end) = 13 weeks
            - `Annual` - timedelta(start - end) = 52 weeks
    - `auc:StartTimestamp`, `auc:IntervalFrequency`
        - Data presented by `auc:IntervalReading` is for the timespan AFTER the `auc:StartTimestamp`
        - `auc:EndTimestamp` = `auc:StartTimestamp` + `auc:IntervalFrequency`
    - `auc:EndTimestamp`, `auc:IntervalFrequency`
        - Data presented by `auc:IntervalReading` is for the timespan BEFORE the `auc:Endimestamp`
        - `auc:StartTimestamp` = `auc:EndTimestamp` - `auc:IntervalFrequency`

## ReadingType
The auc:ReadingType is used to define what the value provided in the auc:IntervalReading means.  The enumerations are described further below
- `Point` declares the value is a spot measurement at a specific point in time.  Examples include sampling power, voltage, current, temperature, humidity, etc.  In this case, NO `auc:IntervalFrequency` should be defined.  It is recommended to use `auc:StartTimestamp`, although `auc:EndTimestamp` can be used.  In this case, they both end up meaning the same thing - the moment in time when the data was sampled.
- `Median` declares the value is at the 50th percentile of a range of values.  The value provides a representative statistic for that range.
- `Average` declares the value is the average of a range of values.  The `Average` temperature for an hour might be used instead of individual `Point` elements declared every 10 or 15 minutes as sufficiently representative for that time period.  The value provides a representative statistic for that range.
- `Total` declares the value as the integral of a range of values.  This is used for energy as the integral of power readings over the specified range of time (for a day, a week, a month, etc.).
- `Peak` declares the value as the maximum of a range of values.  The `Peak` electricity demand (power) for a day, month, or year is useful.  The value provides a representative statistic for that range.
- `Minimum` declares the value as the minimum of a range of values.  The `Minimum` temperature for a day, month, or year is useful.  The value provides a representative statistic for that range.