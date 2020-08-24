import os

from tools.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, exemplary_tree, remove_element
from conftest import SCH_DIR


class TestL000OpenStudioSimulation01(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'v2-1-0_L000_OpenStudio_Simulation.sch')
    exemplary_file_name = 'L000_OpenStudio_Simulation_01'
    exemplary_file = os.path.join(SCH_DIR, 'exemplary_files', f"{exemplary_file_name}.xml")

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_no_address(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the address
        tree = remove_element(tree, '//auc:Building/auc:Address')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '(auc:Address/auc:City and auc:Address/auc:State) or auc:ClimateZoneType/auc:ASHRAE/auc:ClimateZone or auc:ClimateZoneType/auc:CaliforniaTitle24/auc:ClimateZone'
            ]})

    def test_fails_when_package_of_measures_scenario_missing(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the address
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:PackageOfMeasures]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                "count(auc:Scenario[@ID='Baseline' and auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref='Baseline' and auc:ScenarioName='Baseline']) = 1"
            ]
        })

    def test_fails_when_package_of_measures_scenario_missing_reference_case(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the address
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:PackageOfMeasures]/auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                "count(auc:Scenario[@ID='Baseline' and auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref='Baseline' and auc:ScenarioName='Baseline']) = 1"
            ]
        })


class TestL000OpenStudioSimulation02(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'v2-1-0_L000_OpenStudio_Simulation.sch')
    exemplary_file_name = 'L000_OpenStudio_Simulation_02'
    exemplary_file = os.path.join(SCH_DIR, 'exemplary_files', f"{exemplary_file_name}.xml")

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_no_climate_zone_type(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the climate zone
        tree = remove_element(tree, '//auc:Building/auc:ClimateZoneType')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                "(auc:Address/auc:City and auc:Address/auc:State) or auc:ClimateZoneType/auc:ASHRAE/auc:ClimateZone or auc:ClimateZoneType/auc:CaliforniaTitle24/auc:ClimateZone"
            ]
        })
