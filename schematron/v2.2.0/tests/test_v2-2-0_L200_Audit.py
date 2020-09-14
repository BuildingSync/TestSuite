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


def _sides_factory(footprint_shape, wall_id='Wall-A'):
    """
    Returns an auc:Sides element containing valid auc:Sides all pointing to the same auc:WallSystem ID
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

    return sides_elem


class TestL200Audit(AssertFailureRolesMixin):
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
