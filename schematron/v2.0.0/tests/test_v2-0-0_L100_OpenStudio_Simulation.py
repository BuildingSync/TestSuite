import os


from tools.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, v2_0_0_SCH_DIR


class TestV200L100OpenStudio(AssertFailureRolesMixin):
    schematron = os.path.join(v2_0_0_SCH_DIR, 'v2-0-0_L100_OpenStudio_Simulation.sch')
    example_file_1 = os.path.join(v2_0_0_SCH_DIR, 'examples', 'L100_OpenStudio_Simulation_01.xml')

    def test_example_file_1_is_valid_with_info_messages(self):
        # -- Act
        _ = validate_schematron(self.schematron, self.example_file_1)

        # -- Assert
        # TODO: Do we want to check all of the [INFO] reports here?
        # self.assert_failure_messages(failures, {
        #     'INFO': [
        #         "Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1",
        #         "Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1",
        #         "Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0"
        #     ]
        # })
