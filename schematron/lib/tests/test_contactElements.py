import os

from lxml import etree
import pytest

from tools.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, sch_from_imported_abstract_pattern, remove_element

DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')


class TestContactElements(AssertFailureRolesMixin):

    def test_con_nameEmailPhone_passes_valid_doc(self):
        # -- Setup
        example_file = os.path.join(DATA_DIR, 'ex01.xml')
        schematron = sch_from_imported_abstract_pattern(
            "contactElements.sch", "con.nameEmailPhone",
            {'parent': 'auc:Contacts/auc:Contact'})

        # -- Act
        failures = validate_schematron(schematron, example_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    @pytest.mark.parametrize("target_element,expected_message", [
        ("auc:ContactName", "element 'auc:ContactName' is REQUIRED EXACTLY ONCE for: 'auc:Contact'"),
        ("auc:ContactEmailAddresses/auc:ContactEmailAddress", "element 'auc:EmailAddress' within element 'auc:ContactEmailAddresses/auc:ContactEmailAddress' is REQUIRED AT LEAST ONCE for: 'auc:Contact'"),
        ("auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber", "element 'auc:TelephoneNumber' within element 'auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' is REQUIRED AT LEAST ONCE for: 'auc:Contact'"),
    ])
    def test_con_nameEmailPhone_fails_when_contact_missing_element(self, target_element, expected_message):
        # -- Setup
        example_tree = etree.parse(os.path.join(DATA_DIR, 'ex01.xml'))
        schematron = sch_from_imported_abstract_pattern(
            "contactElements.sch", "con.nameEmailPhone",
            {'parent': 'auc:Contacts/auc:Contact'})

        # make sure it's valid
        failures = validate_schematron(schematron, example_tree)

        # -- Act
        # remove the element
        remove_element(example_tree, f'//auc:Facilities/auc:Facility/auc:Contacts/auc:Contact[1]/{target_element}')
        failures = validate_schematron(schematron, example_tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    def test_con_atleastOneAuditorAndOneOwner_passes_valid_doc(self):
        # -- Setup
        example_file = os.path.join(DATA_DIR, 'ex01.xml')
        schematron = sch_from_imported_abstract_pattern(
            "contactElements.sch", "con.atleastOneAuditorAndOneOwner",
            {'parent': 'auc:Facility/auc:Contacts'})

        # -- Act
        failures = validate_schematron(schematron, example_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    @pytest.mark.parametrize("target_element,expected_message", [
        ("auc:Contact/auc:ContactRoles/auc:ContactRole[text() = 'Energy Auditor']", "element 'auc:Contact' with child element 'auc:ContactRoles/auc:ContactRole' with value 'Energy Auditor' is REQUIRED AT LEAST ONCE for: 'auc:Contacts’. Current number of occurrences: 0"),
        ("auc:Contact/auc:ContactRoles/auc:ContactRole[text() = 'Owner']", "element 'auc:Contact' with child element 'auc:ContactRoles/auc:ContactRole' with value 'Owner' is REQUIRED AT LEAST ONCE for: 'auc:Contacts’. Current number of occurrences: 0"),
    ])
    def test_con_atleastOneAuditorAndOneOwner_fails_when_missing_element(self, target_element, expected_message):
        # -- Setup
        example_tree = etree.parse(os.path.join(DATA_DIR, 'ex01.xml'))
        schematron = sch_from_imported_abstract_pattern(
            "contactElements.sch", "con.atleastOneAuditorAndOneOwner",
            {'parent': 'auc:Facility/auc:Contacts'})

        # make sure it's valid
        failures = validate_schematron(schematron, example_tree)

        # -- Act
        # remove the element
        remove_element(example_tree, f'//auc:Facilities/auc:Facility/auc:Contacts/{target_element}')
        failures = validate_schematron(schematron, example_tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })
