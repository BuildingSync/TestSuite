# Description
This directory provides walk through examples for generating BuildingSync documents.

# Typical Tasks

## Create a Single Building

Creating a single building is the simplest task to accomplish using BuildingSync.  With many buildings, it is also necessary to stub out different systems and schedules.  The following XML template can be reused as a base for many documents.  Note that the ID attributes for Facility, Site, and Building should be changed by the user.
```xml
<?xml version="1.0" encoding="utf-8" ?>
<auc:BuildingSync xmlns:auc="http://buildingsync.net/schemas/bedes-auc/2019"
  xsi:schemaLocation="http://buildingsync.net/schemas/bedes-auc/2019 https://raw.githubusercontent.com/BuildingSync/schema/1c73127d389b779c6b74029be72c6e9ff3187113/BuildingSync.xsd"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <auc:Facilities>
    <auc:Facility ID="Facility-1">
      <auc:Sites>
        <auc:Site ID="Site-1">
          <auc:Buildings>
            <auc:Building ID="Building-1"></auc:Building>
          </auc:Buildings>
        </auc:Site>
      </auc:Sites>
      <auc:Systems></auc:Systems>
      <auc:Schedules>
        <auc:Schedule></auc:Schedule>
      </auc:Schedules>
    </auc:Facility>
  </auc:Facilities>
</auc:BuildingSync>
```

## Create Two Buildings on a Single Site
Certain elements can be defined at multiple levels in the BuildingSync hierarchy.  For example, the `auc:ClimateZonetype` and `auc:Address` elements can be defined for a Building and / or a Site.  In general, we will follow DRY principles.  For example, given two buildings with different street addresses on the same site, best practice would be to define it as such:
```xml
        <auc:Site ID="Site-1">
          <auc:Address>
            <auc:City>Chicago</auc:City>
            <auc:State>IL</auc:State>
            <auc:PostalCode>60606</auc:PostalCode>
          </auc:Address>
          <auc:ClimateZoneType>
            <auc:ASHRAE>
              <auc:ClimateZone>5A</auc:ClimateZone>
            </auc:ASHRAE>
          </auc:ClimateZoneType>
          <auc:Buildings>
            <auc:Building ID="Building-1">
              <auc:Address>
                <auc:StreetAddressDetail>
                  <auc:Simplified>
                    <auc:StreetAddress>233 S Wacker Dr</auc:StreetAddress>
                  </auc:Simplified>
                </auc:StreetAddressDetail>
              </auc:Address>
            </auc:Building>
            <auc:Building ID="Building-2">
              <auc:Address>
                <auc:StreetAddressDetail>
                  <auc:Simplified>
                    <auc:StreetAddress>230 S Wacker Dr</auc:StreetAddress>
                  </auc:Simplified>
                </auc:StreetAddressDetail>
              </auc:Address>
            </auc:Building>
          </auc:Buildings>
        </auc:Site>
```

