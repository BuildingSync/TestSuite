import os

from testsuite.constants import BSYNC_NSMAP
from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, exemplary_tree, remove_element, v2_3_0_SCH_DIR


class TestL000OpenStudioSimulation01(AssertFailureRolesMixin):
    schematron = os.path.join(v2_3_0_SCH_DIR, 'v2-3-0_L000_OpenStudio_Pre-Simulation.sch')
    exemplary_file_name = 'L000_OpenStudio_Pre-Simulation_01'
    exemplary_file = os.path.join(v2_3_0_SCH_DIR, 'exemplary_files', f"{exemplary_file_name}.xml")

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_no_address(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.3.0')

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
                'auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)'
            ]})

    def test_fails_when_baseline_scenario_missing(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.3.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        scenario_xpath = '//auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus/text()="Not Started"]'
        scenario_element = tree.xpath(scenario_xpath, namespaces=BSYNC_NSMAP)
        assert len(scenario_element) == 1

        # remove the scenario
        tree = remove_element(tree, scenario_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # Only worry about the first failure
        failures = [failures[0]]
        self.assert_failure_messages(failures, {
            'ERROR': [
                'An auc:Building should be linked to an auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus]'
            ]
        })

    def test_fails_when_scenario_missing_linked_building(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.3.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        scenario_linked_building_xpath = '//auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus/text()="Not Started"]/auc:LinkedPremises/auc:Building'
        scenario_element = tree.xpath(scenario_linked_building_xpath, namespaces=BSYNC_NSMAP)
        assert len(scenario_element) == 1

        # remove the building
        tree = remove_element(tree, scenario_linked_building_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                'An auc:Building should be linked to an auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus]',
                'All Scenarios should be linked to a Building'
            ]
        })


class TestL000OpenStudioSimulation02(AssertFailureRolesMixin):
    schematron = os.path.join(v2_3_0_SCH_DIR, 'v2-3-0_L000_OpenStudio_Pre-Simulation.sch')
    exemplary_file_name = 'L000_OpenStudio_Pre-Simulation_02'
    exemplary_file = os.path.join(v2_3_0_SCH_DIR, 'exemplary_files', f"{exemplary_file_name}.xml")

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_no_climate_zone_type(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.3.0')

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
                'auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)'
            ]
        })
