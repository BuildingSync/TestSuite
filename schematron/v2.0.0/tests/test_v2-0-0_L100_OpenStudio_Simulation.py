import os


from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, v2_0_0_SCH_DIR


class TestV200L100OpenStudio(AssertFailureRolesMixin):
    schematron = os.path.join(v2_0_0_SCH_DIR, 'v2-0-0_L100_OpenStudio_Simulation.sch')
    example_file_1 = os.path.join(v2_0_0_SCH_DIR, 'examples', 'L100_OpenStudio_Simulation_01.xml')

    def test_example_file_1_is_valid_with_info_messages(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.example_file_1)

        # -- Assert
        # check that there are no warnings or errors - there are many infos
        errors = [f for f in failures if f.role == 'ERROR']
        assert len(errors) == 0, f'There should be no ERRORs: {errors}'
        warnings = [f for f in failures if f.role == 'WARNING']
        assert len(warnings) == 0, f'There should be no WARNINGS: {warnings}'
