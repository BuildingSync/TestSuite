# Description
This directory provides walk through examples for different system types to be defined using the BuildingSync XML Schema.  It will serve as a reference for the following:
- How to create different 'System' types
- How to link a 'System' to a 'Section' within a building
- How to specify a 'System' only provides heating / cooling / ventilation to a portion of the 'Section'

Each of the example directories will have README documentation, walking the user through creation of the specific elements.

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
						<auc:Building ID="Building-1">
						</auc:Building>
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
            <auc:Building>
              
            </auc:Building>
            <auc:Building ID="Building-1">
              <auc:YearOfConstruction/>
              <auc:Address>
                <auc:City/>
              </auc:Address>
            </auc:Building>
          </auc:Buildings>
        </auc:Site>
      </auc:Sites>
      <auc:Systems/>
      <auc:Schedules>
        <auc:Schedule/>
      </auc:Schedules>
    </auc:Facility>
  </auc:Facilities>
</auc:BuildingSync>
```

```xml

```

## Add Level 100 Site Information
For a Level 100 BuildingSync document, the `auc:ClimateZoneType` element must be defined at the site level.  



## Add Level 100 Building Information
For a Level 100 BuildingSync file, specific information must be added at the building level.  This includes the following: