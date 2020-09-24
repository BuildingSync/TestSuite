import os

from lxml import etree
import pytest

from tools.constants import BSYNC_NSMAP, BSYNC_NS
from tools.validate_sch import validate_schematron

from schematron.conftest import AssertFailureRolesMixin, v2_2_0_SCH_DIR, exemplary_tree, replace_element, remove_element


def qname(tag):
    return etree.QName(BSYNC_NS, tag)


sides_by_footprint = {
    'Rectangular': ['A1', 'B1', 'C1', 'D1'],
    'L-Shape': ['A1', 'B1', 'A2', 'B2', 'C1', 'D1'],
    'U-Shape': ['A1', 'B1', 'A2', 'D1', 'A3', 'B2', 'C1', 'D2'],
    'T-Shape': ['A1', 'B1', 'C1', 'B2', 'C2', 'D1', 'C3', 'D2'],
    'H-Shape': ['A1', 'B1', 'A2', 'D1', 'A3', 'B2', 'C1', 'D2', 'C2', 'B3', 'C3', 'D3'],
    'O-Shape': ['A1', 'B1', 'C1', 'D1', 'A2', 'B2', 'C2', 'D2'],
}


def _sides_factory(footprint_shape, wall_id='Wall-A', window_id='Window-A', door_id='Door-A'):
    """
    Returns an auc:Sides element containing valid auc:Sides all pointing to the same wall, windows, and doors ID
    """

    side_names = sides_by_footprint.get(footprint_shape)
    if side_names is None:
        raise Exception(f'Invalid footprint shape: "{footprint_shape}"')

    sides_elem = etree.Element(qname('Sides'), nsmap=BSYNC_NSMAP)
    for side_name in side_names:
        side_elem = etree.SubElement(sides_elem, qname('Side'), nsmap=BSYNC_NSMAP)

        side_num_elem = etree.SubElement(side_elem, qname('SideNumber'), nsmap=BSYNC_NSMAP)
        side_num_elem.text = side_name

        wall_ids_elem = etree.SubElement(side_elem, qname('WallIDs'), nsmap=BSYNC_NSMAP)
        wall_id_elem = etree.SubElement(wall_ids_elem, qname('WallID'), nsmap=BSYNC_NSMAP, IDref=wall_id)
        wall_area_elem = etree.SubElement(wall_id_elem, qname('WallArea'), nsmap=BSYNC_NSMAP)
        wall_area_elem.text = '123'

        window_ids_elem = etree.SubElement(side_elem, qname('WindowIDs'), nsmap=BSYNC_NSMAP)
        window_id_elem = etree.SubElement(window_ids_elem, qname('WindowID'), nsmap=BSYNC_NSMAP, IDref=window_id)
        window_area_elem = etree.SubElement(window_id_elem, qname('FenestrationArea'), nsmap=BSYNC_NSMAP)
        window_area_elem.text = '123'

        door_ids_elem = etree.SubElement(side_elem, qname('DoorIDs'), nsmap=BSYNC_NSMAP)
        door_id_elem = etree.SubElement(door_ids_elem, qname('DoorID'), nsmap=BSYNC_NSMAP, IDref=door_id)
        door_area_elem = etree.SubElement(door_id_elem, qname('FenestrationArea'), nsmap=BSYNC_NSMAP)
        door_area_elem.text = '123'

    return sides_elem


class TestL200AuditMiscellaneous(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', 'L200_Audit.xml')

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_is_invalid_when_schedule_types_differ_inside_schedule_details(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace a ScheduleCategory with something that will be different from
        # the other ScheduleCategories
        elem = tree.xpath('//auc:Schedules/auc:Schedule[1]/auc:ScheduleDetails[1]/auc:ScheduleDetail[1]/auc:ScheduleCategory', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        elem.text = 'Bogus Category'

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['All auc:ScheduleDetail within an auc:ScheduleDetails should have the same auc:ScheduleCategory']
        })

    def test_runs_generation_storage_systems_tests_when_they_exist(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # -- Act
        failures = validate_schematron(
            self.schematron,
            tree,
            phase='multigeneration_and_onsite_renewable_energy_systems',
            # using strict here requires that all rule contexts are fired (ie none can be skipped)
            strict_context=True)

        # -- Assert
        self.assert_failure_messages(failures, {})


class TestL200AuditEnvelopeSystems(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', 'L200_Audit.xml')

    @pytest.mark.parametrize("footprint_shape", [
        ("Rectangular"),
        ("L-Shape"),
        ("U-Shape"),
        ("T-Shape"),
        ("H-Shape"),
        ("O-Shape")])
    def test_footprint_shape_and_number_of_sides_tests_work_as_expected(self, footprint_shape):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # replace auc:FootprintShape and auc:Sides
        section_elem = tree.xpath('//auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]', namespaces=BSYNC_NSMAP)
        assert len(section_elem) == 1
        section_elem = section_elem[0]

        footprint_elem = section_elem.xpath('auc:FootprintShape', namespaces=BSYNC_NSMAP)
        assert len(footprint_elem) == 1
        footprint_elem = footprint_elem[0]
        footprint_elem.text = footprint_shape

        replace_element(section_elem, 'auc:Sides', _sides_factory(footprint_shape))

        # make sure it's valid with substituted elements
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove an auc:Side to make it invalid
        remove_element(section_elem, 'auc:Sides/auc:Side[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        expected_sides = len(sides_by_footprint[footprint_shape])
        self.assert_failure_messages(failures, {
            'ERROR': [f'Incorrect number of auc:Side elements for footprint shape "{footprint_shape}" (found {expected_sides - 1})']
        })

    def test_all_fenestration_tests_are_run(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # -- Act
        failures = validate_schematron(
            self.schematron,
            tree,
            phase='building_envelope_-_fenestration',
            # using strict here requires that all rule contexts are fired (ie none can be skipped)
            strict_context=True)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_is_invalid_when_ground_coupling_is_slab_on_grade_and_invalid(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # replace the ground coupling with another valid ground coupling
        new_coupling_xml = f"""
        <auc:GroundCoupling xmlns:auc="{BSYNC_NS}">
            <auc:SlabOnGrade>
                <auc:SlabUFactor>0.5</auc:SlabUFactor>
            </auc:SlabOnGrade>
        </auc:GroundCoupling>
        """
        new_coupling_tree = etree.fromstring(new_coupling_xml)
        ground_coupling_xpath = '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Systems/auc:FoundationSystems/auc:FoundationSystem/auc:GroundCouplings/auc:GroundCoupling'
        replace_element(tree, ground_coupling_xpath, new_coupling_tree)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove an element from the coupling
        remove_xpath = ground_coupling_xpath + '/auc:SlabOnGrade/auc:SlabUFactor'
        remove_element(tree, remove_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'WARNING': ['auc:SlabRValue or auc:SlabUFactor']
        })

    def test_is_invalid_when_ground_coupling_is_basement_and_invalid(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # replace the ground coupling with another valid ground coupling
        new_coupling_xml = f"""
        <auc:GroundCoupling xmlns:auc="{BSYNC_NS}">
            <auc:Basement>
                <auc:FoundationWallConstruction>Concrete poured</auc:FoundationWallConstruction>
                <auc:FoundationWallUFactor>0.5</auc:FoundationWallUFactor>
            </auc:Basement>
        </auc:GroundCoupling>
        """
        new_coupling_tree = etree.fromstring(new_coupling_xml)
        ground_coupling_xpath = '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Systems/auc:FoundationSystems/auc:FoundationSystem/auc:GroundCouplings/auc:GroundCoupling'
        replace_element(tree, ground_coupling_xpath, new_coupling_tree)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove an element from the coupling
        remove_xpath = ground_coupling_xpath + '/auc:Basement/auc:FoundationWallUFactor'
        remove_element(tree, remove_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'WARNING': ['auc:FoundationWallRValue or auc:FoundationWallUFactor']
        })

    def test_is_invalid_when_ground_coupling_is_crawlspace_ventilated_and_invalid(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # replace the ground coupling with another valid ground coupling
        new_coupling_xml = f"""
        <auc:GroundCoupling xmlns:auc="{BSYNC_NS}">
            <auc:Crawlspace>
                <auc:CrawlspaceVenting>
                    <auc:Ventilated>
                        <auc:FloorUFactor>0.5</auc:FloorUFactor>
                    </auc:Ventilated>
                </auc:CrawlspaceVenting>
            </auc:Crawlspace>
        </auc:GroundCoupling>
        """
        new_coupling_tree = etree.fromstring(new_coupling_xml)
        ground_coupling_xpath = '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Systems/auc:FoundationSystems/auc:FoundationSystem/auc:GroundCouplings/auc:GroundCoupling'
        replace_element(tree, ground_coupling_xpath, new_coupling_tree)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove an element from the coupling
        remove_xpath = ground_coupling_xpath + '/auc:Crawlspace/auc:CrawlspaceVenting/auc:Ventilated/auc:FloorUFactor'
        remove_element(tree, remove_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'WARNING': ['auc:FloorRValue or auc:FloorUFactor']
        })

    def test_is_invalid_when_ground_coupling_is_crawlspace_unventilated_and_invalid(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # replace the ground coupling with another valid ground coupling
        new_coupling_xml = f"""
        <auc:GroundCoupling xmlns:auc="{BSYNC_NS}">
            <auc:Crawlspace>
                <auc:CrawlspaceVenting>
                    <auc:Unventilated>
                        <auc:FoundationWallUFactor>0.5</auc:FoundationWallUFactor>
                    </auc:Unventilated>
                </auc:CrawlspaceVenting>
            </auc:Crawlspace>
        </auc:GroundCoupling>
        """
        new_coupling_tree = etree.fromstring(new_coupling_xml)
        ground_coupling_xpath = '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Systems/auc:FoundationSystems/auc:FoundationSystem/auc:GroundCouplings/auc:GroundCoupling'
        replace_element(tree, ground_coupling_xpath, new_coupling_tree)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove an element from the coupling
        remove_xpath = ground_coupling_xpath + '/auc:Crawlspace/auc:CrawlspaceVenting/auc:Unventilated/auc:FoundationWallUFactor'
        remove_element(tree, remove_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'WARNING': ['auc:FoundationWallRValue or auc:FoundationWallUFactor']
        })

    def test_is_invalid_when_no_section_whole_building(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        building_elem = tree.xpath('//auc:Buildings/auc:Building', namespaces=BSYNC_NSMAP)
        assert len(building_elem) == 1
        building_elem = building_elem[0]

        # remove auc:Section[auc:SectionType = "Whole building"]
        remove_element(building_elem, 'auc:Sections/auc:Section[auc:SectionType = "Whole building"]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # This breaks many things, but just want to make sure it breaks.  Only checking first error.
        failures = [failures[0]]
        self.assert_failure_messages(failures, {
            'ERROR': ['/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]/auc:Roofs/auc:Roof']
        })

    def test_is_invalid_when_no_roof_system_exists_under_section_whole_building(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        section_elem = tree.xpath('//auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]', namespaces=BSYNC_NSMAP)
        assert len(section_elem) == 1
        section_elem = section_elem[0]

        roof_elem = section_elem.xpath('auc:Roofs/auc:Roof', namespaces=BSYNC_NSMAP)
        assert len(roof_elem) == 1

        # remove auc:Roof
        remove_element(section_elem, 'auc:Roofs/auc:Roof[1]')
        roof_elem = section_elem.xpath('auc:Roofs/auc:Roof', namespaces=BSYNC_NSMAP)
        assert len(roof_elem) == 0

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # Same error as previous
        self.assert_failure_messages(failures, {
            'ERROR': ['/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]/auc:Roofs/auc:Roof']
        })


class TestL200AuditHvacSystems(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    example_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'HVAC_example1.xml')

    @pytest.mark.parametrize("xpath_to_remove", [
        '//auc:CoolingPlant[1]/auc:YearInstalled',
        '//auc:HeatingPlant[1]/auc:YearInstalled',
        '//auc:CondenserPlant[1]/auc:YearInstalled',
        '//auc:HeatingAndCoolingSystems/auc:Deliveries/auc:Delivery[1]/auc:YearInstalled',
        '//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)]/auc:YearInstalled',
        '//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)]/auc:YearInstalled',
    ])
    def test_is_invalid_when_missing_year_installed(self, xpath_to_remove):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_year_installed')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['auc:YearInstalled']
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:CoolingPlant/auc:DistrictChilledWater/auc:Capacity', 'auc:Capacity'),
        ('//auc:CoolingPlant/auc:Chiller/auc:Capacity', 'auc:Capacity'),
        ('//auc:HeatingPlant/auc:Boiler/auc:InputCapacity', 'auc:InputCapacity'),
        ('//auc:HeatingPlant/auc:DistrictHeating/auc:OutputCapacity', 'auc:OutputCapacity'),
        ('//auc:HeatingPlant/auc:SolarThermal/auc:OutputCapacity', 'auc:OutputCapacity'),
        ('//auc:HeatingAndCoolingSystems/auc:Deliveries/auc:Delivery[1]/auc:Capacity', 'auc:Capacity'),
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)]/auc:Capacity', 'auc:Capacity'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)]/auc:OutputCapacity', 'auc:OutputCapacity'),
    ])
    def test_is_invalid_when_missing_capacity(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_design_capacity')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:CoolingPlant[1]/auc:CoolingPlantCondition', 'auc:CoolingPlantCondition'),
        ('//auc:HeatingPlant[1]/auc:HeatingPlantCondition', 'auc:HeatingPlantCondition'),
        ('//auc:CondenserPlants/auc:CondenserPlant[1]/auc:CondenserPlantCondition', 'auc:CondenserPlantCondition'),
        ('//auc:HeatingAndCoolingSystems/auc:Deliveries/auc:Delivery[1]/auc:DeliveryCondition', 'auc:DeliveryCondition'),
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)]/auc:CoolingSourceCondition', 'auc:CoolingSourceCondition'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)]/auc:HeatingSourceCondition', 'auc:HeatingSourceCondition'),
        ('//auc:DuctSystems/auc:DuctSystem/auc:DuctInsulationCondition', 'auc:DuctInsulationCondition'),
    ])
    def test_is_invalid_when_missing_condition(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_condition')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:HeatingPlant/auc:Boiler/auc:BoilerType', 'auc:BoilerType'),
        ('//auc:HeatingPlant/auc:DistrictHeating/auc:DistrictHeatingType', 'auc:DistrictHeatingType'),
        ('//auc:HeatingPlant/auc:SolarThermal/auc:AnnualHeatingEfficiencyValue', 'auc:AnnualHeatingEfficiencyValue'),
        ('//auc:CoolingPlant/auc:DistrictChilledWater/auc:AnnualCoolingEfficiencyValue', 'auc:AnnualCoolingEfficiencyValue'),
        ('//auc:CoolingPlant/auc:Chiller/auc:ChillerType', 'auc:ChillerType'),
        ('//auc:CondenserPlant/auc:WaterCooled/auc:WaterCooledCondenserType', 'auc:WaterCooledCondenserType'),
        ('//auc:CondenserPlant/auc:AirCooled/auc:CondenserFanSpeedOperation', 'auc:CondenserFanSpeedOperation'),
        ('//auc:CondenserPlant/auc:GroundSource/auc:GroundSourceType', 'auc:GroundSourceType'),
    ])
    def test_is_invalid_when_plant_is_missing_required_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_central_plant')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    def test_is_invalid_when_delivery_is_missing_heating_and_cooling_source(self):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, '//auc:Delivery[1]/auc:HeatingSourceID')
        remove_element(tree, '//auc:Delivery[1]/auc:CoolingSourceID')

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_sources')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['auc:HeatingSourceID or auc:CoolingSourceID']
        })

    @pytest.mark.parametrize("xpath_to_source_id, expected_message", [
        ('//auc:Delivery[1]/auc:HeatingSourceID', 'auc:HeatingSourceID must point to a valid auc:HeatingSource'),
        ('//auc:Delivery[1]/auc:CoolingSourceID', 'auc:CoolingSourceID must point to a valid auc:CoolingSource'),
    ])
    def test_is_invalid_when_delivery_heating_or_cooling_source_points_to_bad_source(self, xpath_to_source_id, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)

        # switch the id to something invalid
        source_id_elem = tree.xpath(xpath_to_source_id, namespaces=BSYNC_NSMAP)
        assert len(source_id_elem) == 1
        source_id_elem = source_id_elem[0]
        source_id_elem.set('IDref', 'bogus')

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_sources')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    def test_is_invalid_when_central_air_distribution_is_invalid(self):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, '//auc:Deliveries/auc:Delivery/auc:DeliveryType/auc:CentralAirDistribution/auc:AirDeliveryType')

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_delivery_type_air_delivery')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['auc:AirDeliveryType']
        })

    def test_is_invalid_when_air_distribution_delivery_type_is_central_fan_and_not_linked_to_fan_system(self):
        # -- Setup
        tree = etree.parse(self.example_file)

        # remove the linked fan to make it invalid
        delivery_elem = tree.xpath('//auc:Deliveries/auc:Delivery[auc:DeliveryType/auc:CentralAirDistribution/auc:AirDeliveryType]', namespaces=BSYNC_NSMAP)
        assert len(delivery_elem) == 1
        delivery_elem = delivery_elem[0]
        delivery_id = delivery_elem.attrib['ID']
        remove_element(tree, f'//auc:Systems/auc:FanSystems/auc:FanSystem[auc:LinkedSystemIDs/auc:LinkedSystemID/@IDref = "{delivery_id}"]')

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_delivery_type_air_delivery')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['auc:Delivery ID must be linked to a valid auc:FanSystem']
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:Delivery/auc:DeliveryType/auc:ZoneEquipment/auc:FanBased/auc:FanBasedDistributionType/auc:FanCoil/auc:FanCoilType', 'auc:FanCoilType'),
        ('//auc:Delivery/auc:DeliveryType/auc:ZoneEquipment/auc:Convection/auc:ConvectionType', 'auc:ConvectionType'),
        ('//auc:Delivery/auc:DeliveryType/auc:ZoneEquipment/auc:Radiant/auc:RadiantType', 'auc:RadiantType'),
    ])
    def test_is_invalid_when_delivery_type_zone_equipment_and_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_delivery_type_air_delivery')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:Deliveries/auc:Delivery/auc:DeliveryType/auc:CentralAirDistribution/auc:FanBased/auc:AirSideEconomizer', 'auc:FanBased/auc:AirSideEconomizer'),
        ('//auc:HeatRecoverySystems/auc:HeatRecoverySystem/auc:HeatRecoveryType', 'auc:HeatRecoveryType'),
    ])
    def test_is_invalid_when_outdoor_air_control_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_delivery_outdoor_air_control')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:Systems/auc:PumpSystems/auc:PumpSystem/auc:LinkedSystemIDs/auc:LinkedSystemID[@IDref = "HeatingPlant-A"]', 'auc:HeatingPlant must be linked to an auc:PumpSystem through auc:PumpSystem/auc:LinkedSystemIDs'),
        ('//auc:Systems/auc:PumpSystems/auc:PumpSystem/auc:LinkedSystemIDs/auc:LinkedSystemID[@IDref = "CoolingPlant-A"]', 'auc:CoolingPlant must be linked to an auc:PumpSystem through auc:PumpSystem/auc:LinkedSystemIDs'),
        ('//auc:Systems/auc:PumpSystems/auc:PumpSystem/auc:LinkedSystemIDs/auc:LinkedSystemID[@IDref = "CondenserPlant-A"]', 'auc:CondenserPlant must be linked to an auc:PumpSystem through auc:PumpSystem/auc:LinkedSystemIDs'),
    ])
    def test_is_invalid_when_plant_is_not_linked_to_pump(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_delivery_type_water_delivery')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:HeatingPlant[1]/auc:ControlSystemTypes/auc:ControlSystemType/*', 'auc:HeatingPlant must have at least one auc:ControlSystemType child'),
        ('//auc:CoolingPlant[1]/auc:ControlSystemTypes/auc:ControlSystemType/*', 'auc:CoolingPlant must have at least one auc:ControlSystemType child'),
        ('//auc:CondenserPlant[1]/auc:ControlSystemTypes/auc:ControlSystemType/*', 'auc:CondenserPlant must have at least one auc:ControlSystemType child'),
    ])
    def test_is_invalid_when_plant_is_missing_controls(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_controls_type')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)]/auc:Controls/auc:Control/*/auc:ControlSystemType/*', 'auc:CoolingSource must have at least one auc:ControlSystemType child'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)]/auc:Controls/auc:Control/*/auc:ControlSystemType/*', 'auc:HeatingSource must have at least one auc:ControlSystemType child'),
        ('//auc:HeatingAndCoolingSystems/auc:Deliveries/auc:Delivery[1]/auc:Controls/auc:Control/*/auc:ControlSystemType/*', 'auc:Delivery must have at least one auc:ControlSystemType child'),
    ])
    def test_is_invalid_when_source_or_delivery_is_missing_controls(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_controls_type')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove", [
        ('//auc:HVACSystem/auc:Plants/auc:HeatingPlants/auc:HeatingPlant[1]/auc:BuildingAutomationSystem'),
        ('//auc:HVACSystem/auc:Plants/auc:CoolingPlants/auc:CoolingPlant[1]/auc:BuildingAutomationSystem'),
        ('//auc:HVACSystem/auc:Plants/auc:CondenserPlants/auc:CondenserPlant[1]/auc:BuildingAutomationSystem'),
    ])
    def test_is_invalid_when_missing_building_automation_system(self, xpath_to_remove):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_building_automation_system')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['auc:BuildingAutomationSystem']
        })
