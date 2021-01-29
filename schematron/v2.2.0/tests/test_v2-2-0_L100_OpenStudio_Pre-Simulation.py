import os


from testsuite.constants import BSYNC_NSMAP
from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, exemplary_tree, remove_element, v2_2_0_SCH_DIR


class TestL100OpenStudioSimulation(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L100_OpenStudio_Pre-Simulation.sch')
    exemplary_file_name = 'L100_OpenStudio_Pre-Simulation_01'
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', f"{exemplary_file_name}.xml")

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_building_has_no_sections(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # ensure sections exist as expected
        section_xpath = '//auc:Sections/auc:Section[auc:SectionType/text()="Space function"]'
        section_elements = tree.xpath(section_xpath, namespaces=BSYNC_NSMAP)
        assert len(section_elements) == 2

        # remove the first section element, no failures
        tree = remove_element(tree, '//auc:Sections/auc:Section[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {})

        # remove the second section element, failures should occur
        tree = remove_element(tree, '//auc:Sections/auc:Section[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section[auc:SectionType/text() = 'Space function']"
            ]
        })

    def test_fails_when_no_hvac_system_linked_to_section_space_function(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # ensure hvac systems exist as expected
        hvac_xpath = '//auc:HVACSystems/auc:HVACSystem[auc:PrincipalHVACSystemType]'
        hvac_elements = tree.xpath(hvac_xpath, namespaces=BSYNC_NSMAP)
        assert len(hvac_elements) == 2

        # remove the first hvac system element
        tree = remove_element(tree, '//auc:HVACSystems/auc:HVACSystem[1]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                "auc:Section[auc:SectionType='Space function'] must have a linked auc:HVACSystem/auc:PrincipalHVACSystem"
            ]
        })

    def test_fails_when_package_has_no_measure(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # ensure simulation status exists as expected
        measure_xpath = '//auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs/auc:MeasureID'
        measure_element = tree.xpath(measure_xpath, namespaces=BSYNC_NSMAP)
        assert len(measure_element) == 1

        # remove the measure
        tree = remove_element(tree, measure_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                "/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:MeasureIDs/auc:MeasureID"
            ]
        })

    def test_infos_when_baseline_simulation_completion_status_is_not_not_started(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # ensure simulation status exists as expected
        simulation_status = '//auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus'
        simulation_element = tree.xpath(simulation_status, namespaces=BSYNC_NSMAP)
        assert len(simulation_element) == 1
        simulation_element = simulation_element[0]
        simulation_element.text = 'Finished'

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'INFO': [
                "Scenario Baseline-Modeled will not have an OSW created for it since the auc:SimulationCompletionStatus is Finished, not Not Started"
            ]
        })

    def test_infos_when_package_simulation_completion_status_is_not_not_started(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # ensure simulation status exists as expected
        simulation_status = '//auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:PackageOfMeasures/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus'
        simulation_element = tree.xpath(simulation_status, namespaces=BSYNC_NSMAP)
        assert len(simulation_element) == 1
        simulation_element = simulation_element[0]
        simulation_element.text = 'Finished'

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'INFO': [
                "Scenario Package-1 will not have an OSW created for it since the auc:SimulationCompletionStatus is Finished, not Not Started"
            ]
        })
