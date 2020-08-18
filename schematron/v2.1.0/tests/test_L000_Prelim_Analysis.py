import os


from tools.validate_sch import validate_schematron
from conftest import AssertFailureRolesMixin, SCH_DIR, golden_tree, remove_element


class TestL000PrelimAnalysis(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'L000_Prelim_Analysis.sch')
    golden_file = os.path.join(SCH_DIR, 'golden_files', 'L000_Prelim_Analysis.xml')

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_measured_scenario_missing(self):
        # -- Setup
        tree = golden_tree('L000_Prelim_Analysis')

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
        tree = golden_tree('L000_Prelim_Analysis')

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
        tree = golden_tree('L000_Prelim_Analysis')

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
        tree = golden_tree('L000_Prelim_Analysis')

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
