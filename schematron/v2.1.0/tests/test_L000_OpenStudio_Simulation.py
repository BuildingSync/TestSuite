import os

from tools.validate_sch import validate_schematron
from conftest import failures_by_role, AssertFailureRolesMixin, golden_tree, remove_element, SCH_DIR

class TestL000OpenStudioSimulation01(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'L000_OpenStudio_Simulation.sch')
    golden_file_name = 'L000_OpenStudio_Simulation_01'
    golden_file = os.path.join(SCH_DIR, 'golden_files', f"{golden_file_name}.xml")

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_roles(failures, {})

    def test_fails_when_no_address(self):
        # -- Setup
        tree = golden_tree(self.golden_file_name)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the address
        tree = remove_element(tree, '//auc:Building/auc:Address')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 1})
        assert failures[0].message == "(auc:Address/auc:City and auc:Address/auc:State) or auc:ClimateZoneType/auc:ASHRAE/auc:ClimateZone or auc:ClimateZoneType/auc:CaliforniaTitle24/auc:ClimateZone"

    def test_fails_when_package_of_measures_scenario_missing(self):
        # -- Setup
        tree = golden_tree(self.golden_file_name)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the address
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:PackageOfMeasures]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 1})
        assert failures[0].message == "count(auc:Scenario[@ID='Baseline' and auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref='Baseline' and auc:ScenarioName='Baseline']) = 1"

    def test_fails_when_package_of_measures_scenario_missing_reference_case(self):
        # -- Setup
        tree = golden_tree(self.golden_file_name)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the address
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:PackageOfMeasures]/auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 1})
        assert failures[
                   0].message == "count(auc:Scenario[@ID='Baseline' and auc:ScenarioType/auc:PackageOfMeasures/auc:ReferenceCase/@IDref='Baseline' and auc:ScenarioName='Baseline']) = 1"


class TestL000OpenStudioSimulation02(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'L000_OpenStudio_Simulation.sch')
    golden_file_name = 'L000_OpenStudio_Simulation_02'
    golden_file = os.path.join(SCH_DIR, 'golden_files', f"{golden_file_name}.xml")

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_roles(failures, {})

    def test_fails_when_no_climate_zone_type(self):
        # -- Setup
        tree = golden_tree(self.golden_file_name)

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_roles(failures, {})

        # remove the climate zone
        tree = remove_element(tree, '//auc:Building/auc:ClimateZoneType')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_roles(failures, {'ERROR': 1})
        assert failures[0].message == "(auc:Address/auc:City and auc:Address/auc:State) or auc:ClimateZoneType/auc:ASHRAE/auc:ClimateZone or auc:ClimateZoneType/auc:CaliforniaTitle24/auc:ClimateZone"
