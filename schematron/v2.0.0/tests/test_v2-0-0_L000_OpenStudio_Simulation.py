import os


from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, v2_0_0_SCH_DIR


class TestV200L000OpenStudio(AssertFailureRolesMixin):
    schematron = os.path.join(v2_0_0_SCH_DIR, 'v2-0-0_L000_OpenStudio_Simulation.sch')
    example_file_1 = os.path.join(v2_0_0_SCH_DIR, 'examples', 'L000_OpenStudio_Simulation_01.xml')
    example_file_2 = os.path.join(v2_0_0_SCH_DIR, 'examples', 'L000_OpenStudio_Simulation_02.xml')

    def test_example_file_1_is_valid_with_info_messages(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.example_file_1)

        # -- Assert
        self.assert_failure_messages(failures, {
            'INFO': [
                "Number of 'auc:City' elements defined at the 'auc:Site' = 1, 'auc:Building' = 0",
                "Number of 'auc:State' elements defined at the 'auc:Site' = 1, 'auc:Building' = 0",
                "Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0"
            ]
        })

    def test_example_file_2_is_valid_with_info_messages(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.example_file_2)

        # -- Assert
        self.assert_failure_messages(failures, {
            'INFO': [
                "Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0",
                "Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0",
                "Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 1, 'auc:Building' = 0"
            ]
        })
