import os


from tools.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, exemplary_tree, remove_element
from conftest import SCH_DIR


class TestL000PrelimAnalysis(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'v2-1-0_L000_Prelim_Analysis.sch')
    exemplary_file = os.path.join(SCH_DIR, 'exemplary_files', 'L000_Prelim_Analysis.xml')

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_measured_scenario_missing(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the measured scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID',
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]',
            ]
        })

    def test_fails_when_measured_scenario_not_linked_to_building(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the measured scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID',
            ]
        })

    def test_fails_when_benchmark_scenario_missing(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Scenario/auc:ScenarioType/auc:Benchmark')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID',
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Benchmark',
            ]
        })

    def test_fails_when_benchmark_scenario_not_linked_to_building(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID'
            ]
        })

    def test_fails_when_no_address_or_climate_zone_type(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.1.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Building/auc:Address')
        tree = remove_element(tree, '//auc:Building/auc:ClimateZoneType')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                'auc:ClimateZoneType/*/auc:ClimateZone or (auc:Address/auc:City and auc:Address/auc:State)'
            ]
        })
