import os

from lxml import etree
import pytest

from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, remove_element, sch_from_imported_pattern

DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')


class TestBuildingElements(AssertFailureRolesMixin):

    def test_be_L000BuildingInfo_passes_valid_doc(self):
        # -- Setup
        example_file = os.path.join(DATA_DIR, 'ex01.xml')
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.L000BuildingInfo")

        # -- Act
        failures = validate_schematron(schematron, example_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    @pytest.mark.parametrize("target_element,expected_message", [
        ('auc:PremisesName', "element 'auc:PremisesName' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:BuildingClassification', "element 'auc:BuildingClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:OccupancyClassification', "element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:YearOfConstruction', "element 'auc:YearOfConstruction' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
    ])
    def test_be_L000BuildingInfo_fails_when_missing_required_Building_element(self, target_element, expected_message):
        # -- Setup
        example_tree = etree.parse(os.path.join(DATA_DIR, 'ex01.xml'))
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.L000BuildingInfo")

        # make sure it's valid
        failures = validate_schematron(schematron, example_tree)

        # -- Act
        # remove the element
        remove_element(example_tree, f'//auc:Buildings/auc:Building/{target_element}')
        failures = validate_schematron(schematron, example_tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    def test_be_simpleLocationDetails_passes_valid_doc(self):
        # -- Setup
        example_file = os.path.join(DATA_DIR, 'ex01.xml')
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.simpleLocationDetails")

        # -- Act
        failures = validate_schematron(schematron, example_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    @pytest.mark.parametrize("target_element,expected_message", [
        ('auc:City', "element 'auc:City' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:State', "element 'auc:State' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:PostalCode', "element 'auc:PostalCode' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress', "element 'auc:StreetAddress' within element 'auc:Address/auc:StreetAddressDetail/auc:Simplified' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
    ])
    def test_be_simpleLocationDetails_fails_when_address_element_missing(self, target_element, expected_message):
        # -- Setup
        example_tree = etree.parse(os.path.join(DATA_DIR, 'ex01.xml'))
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.simpleLocationDetails")

        # make sure it's valid
        failures = validate_schematron(schematron, example_tree)

        # -- Act
        # remove the element
        remove_element(example_tree, f'//auc:Buildings/auc:Building/auc:Address/{target_element}')
        failures = validate_schematron(schematron, example_tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })
