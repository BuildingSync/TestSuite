import os

from lxml import etree

from tools.validate_sch import validate_schematron
from conftest import failures_by_role, AssertFailureRolesMixin, golden_tree, remove_element

class TestL000PrelimAnalysis(AssertFailureRolesMixin):
    schematron = 'schematron/v2.0.0/L000_Prelim_Analysis.sch'
    golden_file = 'schematron/v2.0.0/golden_files/L000_Prelim_Analysis.xml'

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_roles(failures, {})

    def test_fails_when_measured_scenario_missing(self):
        # -- Setup
        tree = golden_tree('L000_Prelim_Analysis')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the measured scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]')
        
        # -- Act 
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 3})

    def test_fails_when_measured_scenario_not_linked_to_building(self):
        # -- Setup
        tree = golden_tree('L000_Prelim_Analysis')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the measured scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID')

        # -- Act 
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 1})

    def test_fails_when_benchmark_scenario_missing(self):
        # -- Setup
        tree = golden_tree('L000_Prelim_Analysis')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Scenario/auc:ScenarioType/auc:Benchmark')

        # -- Act 
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 2})

    def test_fails_when_benchmark_scenario_not_linked_to_building(self):
        # -- Setup
        tree = golden_tree('L000_Prelim_Analysis')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID')

        # -- Act 
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 1})
