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

        replace_element(section_elem, 'auc:Sides', _sides_factory(footprint_shape, window_id='Window-A-Original'))

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

    def test_is_invalid_when_no_wall_exists_under_a_side(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        section_elem = tree.xpath('//auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]', namespaces=BSYNC_NSMAP)
        assert len(section_elem) == 1
        section_elem = section_elem[0]

        side_elem = section_elem.xpath('auc:Sides/auc:Side', namespaces=BSYNC_NSMAP)
        assert len(side_elem) == 4

        # remove wall from first side element
        remove_element(side_elem[0], 'auc:WallIDs/auc:WallID[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['Found an auc:Side with no linked auc:Wall']
        })

    def test_is_invalid_when_no_window_exists_under_a_side(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        section_elem = tree.xpath('//auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]', namespaces=BSYNC_NSMAP)
        assert len(section_elem) == 1
        section_elem = section_elem[0]

        side_elem = section_elem.xpath('auc:Sides/auc:Side', namespaces=BSYNC_NSMAP)
        assert len(side_elem) == 4

        side_elem_0 = side_elem[0]
        side_elem_1 = side_elem[1]

        # remove window from first side element
        remove_element(side_elem_0, 'auc:WindowIDs/auc:WindowID[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'WARNING': ['Found an auc:Side with no linked auc:Window']
        })

        # remove window from second side element
        remove_element(side_elem_1, 'auc:WindowIDs/auc:WindowID[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'WARNING': ['Found an auc:Side with no linked auc:Window', 'Found an auc:Side with no linked auc:Window']
        })

    def test_is_invalid_when_no_foundation_exists_under_section_whole_building(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        section_elem = tree.xpath('//auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]', namespaces=BSYNC_NSMAP)
        assert len(section_elem) == 1
        section_elem = section_elem[0]

        foundation_elem = section_elem.xpath('auc:Foundations/auc:Foundation', namespaces=BSYNC_NSMAP)
        assert len(foundation_elem) == 1
        foundation_elem = foundation_elem[0]

        # remove window from first side element
        remove_element(foundation_elem, 'auc:FoundationID[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section[auc:SectionType = "Whole building"]/auc:Foundations/auc:Foundation/auc:FoundationID',
                      'count(auc:Foundations/auc:Foundation/auc:FoundationID) >= 1']
        })


class TestL200AuditHvacSystems(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    example_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'HVAC_example1.xml')

    @pytest.mark.parametrize("xpath_to_remove", [
        '//auc:CoolingPlant[1]/auc:YearInstalled',
        '//auc:HeatingPlant[1]/auc:YearInstalled',
        '//auc:CondenserPlant[1]/auc:YearInstalled',
        '//auc:HeatingAndCoolingSystems/auc:Deliveries/auc:Delivery[1]/auc:YearInstalled',
        '//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)][1]/auc:YearInstalled',
        '//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)][1]/auc:YearInstalled',
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
        ('//auc:HeatingPlant/auc:DistrictHeating/auc:Capacity', 'auc:Capacity'),
        ('//auc:HeatingPlant/auc:SolarThermal/auc:Capacity', 'auc:Capacity'),
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)][1]/auc:Capacity', 'auc:Capacity'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)][1]/auc:Capacity', 'auc:Capacity'),
        ('//auc:CondenserPlants/auc:CondenserPlant[1]/*/auc:Capacity', 'auc:Capacity'),
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
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)][1]/auc:CoolingSourceCondition', 'auc:CoolingSourceCondition'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)][1]/auc:HeatingSourceCondition', 'auc:HeatingSourceCondition'),
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
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource/auc:CoolingSourceType/auc:DX/auc:DXSystemType', 'auc:DXSystemType'),
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource/auc:CoolingSourceType/auc:EvaporativeCooler/auc:EvaporativeCoolingType', 'auc:EvaporativeCoolingType'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource/auc:HeatingSourceType/auc:Furnace/auc:FurnaceType', 'auc:FurnaceType'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource/auc:HeatingSourceType/auc:HeatPump/auc:HeatPumpType', 'auc:HeatPumpType'),
    ])
    def test_is_invalid_when_source_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='hvac_distribution_system_sources')

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
        ('//auc:HeatingAndCoolingSystems/auc:CoolingSources/auc:CoolingSource[not(auc:CoolingSourceType/auc:CoolingPlantID)][1]/auc:Controls/auc:Control/*/auc:ControlSystemType/*', 'auc:CoolingSource must have at least one auc:ControlSystemType child'),
        ('//auc:HeatingAndCoolingSystems/auc:HeatingSources/auc:HeatingSource[not(auc:HeatingSourceType/auc:HeatingPlantID)][1]/auc:Controls/auc:Control/*/auc:ControlSystemType/*', 'auc:HeatingSource must have at least one auc:ControlSystemType child'),
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


class TestL200AuditDhwSystems(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    example_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'DHW_example1.xml')

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem/auc:DomesticHotWaterType/auc:StorageTank/auc:TankHeatingType/auc:Direct/auc:DirectTankHeatingSource/auc:Combustion/auc:CondensingOperation', 'auc:CondensingOperation'),
        ('//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem/auc:DomesticHotWaterType/auc:StorageTank/auc:TankHeatingType/auc:Indirect/auc:IndirectTankHeatingSource/auc:HeatPump/auc:RatedHeatPumpSensibleHeatRatio', 'auc:RatedHeatPumpSensibleHeatRatio'),
        ('//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem/auc:DomesticHotWaterType/auc:StorageTank/auc:TankHeatingType/auc:Indirect/auc:IndirectTankHeatingSource/auc:Solar/auc:SolarThermalSystemType', 'auc:SolarThermalSystemType'),
        ('//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem/auc:DomesticHotWaterType/auc:Instantaneous/auc:InstantaneousWaterHeatingSource/auc:Combustion/auc:CondensingOperation', 'auc:CondensingOperation'),
    ])
    def test_is_invalid_when_dhw_system_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='domestic_hot_water_system')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem[1]/auc:DailyHotWaterDraw', 'auc:DailyHotWaterDraw'),
        ('//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem[1]/auc:DomesticHotWaterType/auc:StorageTank/auc:StorageTankInsulationRValue', 'auc:StorageTankInsulationRValue'),
        ('//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem[1]/auc:Recirculation/auc:RecirculationLoopCount', 'auc:RecirculationLoopCount'),
    ])
    def test_is_invalid_when_dhw_operating_condition_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='dhw_operating_condition')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    def test_is_invalid_when_dhw_general_condition_is_missing(self):
        # -- Setup
        tree = etree.parse(self.example_file)
        condition_xpath = '//auc:DomesticHotWaterSystems/auc:DomesticHotWaterSystem[1]/auc:DomesticHotWaterSystemCondition'
        remove_element(tree, condition_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='dhw_general_condition')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['auc:DomesticHotWaterSystemCondition']
        })


class TestL200AuditLightingSystems(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    example_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'Lighting_example1.xml')

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:LightingSystems/auc:LightingSystem/auc:OutsideLighting', 'auc:OutsideLighting'),
        ('//auc:LightingSystems/auc:LightingSystem/auc:LampType/*/auc:LampLabel', 'auc:LampLabel'),
        ('//auc:LightingSystems/auc:LightingSystem/auc:Controls/auc:Control/auc:Daylighting/auc:ControlSensor', 'auc:ControlSensor'),
        ('//auc:LightingSystems/auc:LightingSystem/auc:NumberOfLampsPerBallast', 'auc:NumberOfLampsPerBallast'),
    ])
    def test_is_invalid_when_lighting_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='lighting')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })


class TestL200AuditLoads(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    example_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'Loads_example1.xml')

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:ProcessLoads/auc:ProcessLoad/auc:ProcessLoadType', 'auc:ProcessLoadType'),
        ('//auc:ProcessLoads/auc:ProcessLoad/auc:LinkedPremises/auc:Section/auc:LinkedSectionID/auc:LinkedScheduleIDs/auc:LinkedScheduleID', 'auc:ProcessLoad\'s link to an auc:Section must include link to an auc:Schedule'),
    ])
    def test_is_invalid_when_process_load_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='process_loads')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:PlugLoads/auc:PlugLoad/auc:WeightedAverageLoad', 'auc:WeightedAverageLoad or (auc:PlugLoadNominalPower and auc:Quantity)'),
        ('//auc:PlugLoads/auc:PlugLoad/auc:LinkedPremises/auc:Section/auc:LinkedSectionID/auc:LinkedScheduleIDs/auc:LinkedScheduleID', 'auc:PlugLoad\'s link to an auc:Section must include link to an auc:Schedule'),
    ])
    def test_is_invalid_when_plug_load_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='plug_loads')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("xpath_to_remove, expected_message", [
        ('//auc:ConveyanceSystems/auc:ConveyanceSystem/auc:ConveyanceSystemType', 'auc:ConveyanceSystemType'),
        ('//auc:ConveyanceSystems/auc:ConveyanceSystem/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID', 'auc:ConveyanceSystem must be linked to an auc:Building'),
    ])
    def test_is_invalid_when_conveyance_system_is_missing_info(self, xpath_to_remove, expected_message):
        # -- Setup
        tree = etree.parse(self.example_file)
        remove_element(tree, xpath_to_remove)

        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='conveyance_equipment')

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })


class TestL200AuditSectionSystems(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    example_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'Section_System_Links.xml')

    @pytest.mark.parametrize("section_occupancy_classification,expected_errors", [
        ('Manufactured home', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Single family', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Multifamily', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Multifamily with commercial', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Multifamily individual unit', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Public housing', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Residential', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Health care-Pharmacy', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Skilled nursing facility', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended', 'A linked auc:ProcessLoad is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Health care-Residential treatment center', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Inpatient hospital', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:DomesticHotWaterSystem is required', 'A linked auc:CookingSystem is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Health care-Outpatient rehabilitation', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Diagnostic center', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Outpatient facility', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Outpatient non-diagnostic', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Outpatient surgical', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Veterinary', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care-Morgue or mortuary', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Health care', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended', 'A linked auc:ProcessLoad is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Gas station', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended']}),
        ('Convenience store', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended']}),
        ('Food sales-Grocery store', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended']}),
        ('Food sales', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended']}),
        ('Laboratory-Testing', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Laboratory-Medical', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Laboratory', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Vivarium', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Zoo', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Office-Financial', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Office', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Bank', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Courthouse', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Public safety station-Fire', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Public safety station-Police', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended']}),
        ('Public safety station', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Public safety-Detention center', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:DomesticHotWaterSystem is required', 'A linked auc:CookingSystem is required'], 'WARNING': ['A linked auc:LaundrySystem is recommended']}),
        ('Public safety-Correctional facility', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:DomesticHotWaterSystem is required', 'A linked auc:CookingSystem is required'], 'WARNING': ['A linked auc:LaundrySystem is recommended']}),
        ('Public safety', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Warehouse-Refrigerated', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:RefrigerationSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Warehouse-Unrefrigerated', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:PlugLoad is recommended', 'A linked auc:ProcessLoad is recommended'], 'ERROR': ['A linked auc:LightingSystem is required']}),
        ('Warehouse-Self-storage', {'INFO': ['No linked auc:HVACSystem found', 'No linked auc:PlugLoad found'], 'ERROR': ['A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:RefrigerationSystem is recommended']}),
        ('Warehouse', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Assembly-Religious', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Cultural entertainment', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Social entertainment', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Arcade or casino without lodging', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Convention center', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Indoor arena', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Assembly-Race track', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Stadium', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Stadium (closed)', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Stadium (open)', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Assembly-Public', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Recreation-Pool', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:ProcessLoad is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Recreation-Bowling alley', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:CookingSystem is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Recreation-Fitness center', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended', 'A linked auc:ProcessLoad is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Recreation-Ice rink', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:RefrigerationSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:CookingSystem is recommended']}),
        ('Recreation-Roller rink', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:CookingSystem is recommended']}),
        ('Recreation-Indoor sport', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Recreation', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Education-Adult', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Education-Higher', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Education-Secondary', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Education-Primary', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Education-Preschool or daycare', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Education-Vocational', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Education', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:CookingSystem is recommended']}),
        ('Food service-Fast', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CookingSystem is required']}),
        ('Food service-Full', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CookingSystem is required']}),
        ('Food service-Limited', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CookingSystem is required']}),
        ('Food service-Institutional', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CookingSystem is required']}),
        ('Food service', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CookingSystem is required']}),
        ('Lodging-Barracks', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Lodging-Institutional', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Lodging with extended amenities', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Lodging with limited amenities', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Lodging', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended', 'A linked auc:LaundrySystem is recommended']}),
        ('Retail-Automobile dealership', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Retail-Mall', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Retail-Strip mall', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Retail-Enclosed mall', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Retail-Dry goods retail', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Retail-Hypermarket', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:RefrigerationSystem is required']}),
        ('Retail', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Service-Postal', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Service-Repair', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Service-Laundry or dry cleaning', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:LaundrySystem is required']}),
        ('Service-Studio', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Service-Beauty and health', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Service-Production and assembly', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Service', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Transportation terminal', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended', 'A linked auc:ProcessLoad is recommended']}),
        ('Central Plant', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Water treatment-Wastewater', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Water treatment-Drinking water and distribution', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Water treatment', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Energy generation plant', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Industrial manufacturing plant', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Utility', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Industrial', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Agricultural estate', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:ProcessLoad is required']}),
        ('Mixed-use commercial', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:DomesticHotWaterSystem is recommended']}),
        ('Parking', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:PlugLoad is recommended'], 'ERROR': ['A linked auc:LightingSystem is required'], 'INFO': ['No linked auc:ProcessLoad found']}),
        ('Attic', {'INFO': ['No linked auc:HVACSystem found', 'No linked auc:LightingSystem found', 'No linked auc:PlugLoad found']}),
        ('Basement', {'INFO': ['No linked auc:HVACSystem found', 'No linked auc:LightingSystem found', 'No linked auc:PlugLoad found']}),
        ('Dining area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Living area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Sleeping area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Laundry area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:LaundrySystem is required']}),
        ('Lodging area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Dressing area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Restroom', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Auditorium', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Classroom', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Day room', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Sport play area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Stage', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Spectator area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Office work area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Non-office work area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Common area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Reception area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Waiting area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Transportation waiting area', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Lobby', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Conference room', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Computer lab', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Data center', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:CriticalITSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Printing room', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Media center', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CriticalITSystem is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('Refrigerated storage', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:RefrigerationSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Bar-Nightclub', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:CriticalITSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Bar', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Dance floor', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Trading floor', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CriticalITSystem is required'], 'WARNING': ['A linked auc:ProcessLoad is recommended']}),
        ('TV studio', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CriticalITSystem is required']}),
        ('Security room', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required', 'A linked auc:CriticalITSystem is required']}),
        ('Shipping and receiving', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:PlugLoad is recommended', 'A linked auc:ProcessLoad is recommended'], 'ERROR': ['A linked auc:LightingSystem is required']}),
        ('Mechanical room', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:PlugLoad is recommended'], 'ERROR': ['A linked auc:LightingSystem is required']}),
        ('Chemical storage room', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Non-chemical storage room', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:PlugLoad is recommended'], 'ERROR': ['A linked auc:LightingSystem is required']}),
        ('Janitorial closet', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:PlugLoad is recommended'], 'ERROR': ['A linked auc:LightingSystem is required']}),
        ('Vault', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:PlugLoad is recommended'], 'ERROR': ['A linked auc:LightingSystem is required']}),
        ('Corridor', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required'], 'WARNING': ['A linked auc:PlugLoad is recommended']}),
        ('Deck', {'WARNING': ['A linked auc:LightingSystem is recommended', 'A linked auc:PlugLoad is recommended']}),
        ('Courtyard', {'WARNING': ['A linked auc:LightingSystem is recommended']}),
        ('Atrium', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:LightingSystem is recommended'], 'INFO': ['No linked auc:PlugLoad found']}),
        ('Science park', {'ERROR': ['A linked auc:HVACSystem is required', 'A linked auc:LightingSystem is required', 'A linked auc:PlugLoad is required']}),
        ('Other', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:LightingSystem is recommended', 'A linked auc:PlugLoad is recommended', 'A linked auc:RefrigerationSystem is recommended']}),
        ('Unknown', {'WARNING': ['A linked auc:HVACSystem is recommended', 'A linked auc:LightingSystem is recommended', 'A linked auc:PlugLoad is recommended', 'A linked auc:RefrigerationSystem is recommended']})
    ])
    def test_section_is_invalid_when_missing_required_links(self, section_occupancy_classification, expected_errors):
        # -- Setup
        tree = etree.parse(self.example_file)
        occ_classification_elem = tree.xpath('//auc:Buildings/auc:Building/auc:Sections/auc:Section/auc:OccupancyClassification', namespaces=BSYNC_NSMAP)
        assert len(occ_classification_elem) == 1
        occ_classification_elem = occ_classification_elem[0]
        occ_classification_elem.text = section_occupancy_classification
        # verify it's valid initially
        failures = validate_schematron(self.schematron, tree, phase='section_systems')
        self.assert_failure_messages(failures, {})
        # change the ID of the section to "unlink" the systems and create errors
        section_elem = occ_classification_elem.getparent()
        section_elem.attrib['ID'] = 'Unlinked-Section'
        # -- Act
        failures = validate_schematron(self.schematron, tree, phase='section_systems')
        # -- Assert
        self.assert_failure_messages(failures, expected_errors)
