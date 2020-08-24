import os


from tools.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, v2_0_0_SCH_DIR


class TestV200BricrSeed(AssertFailureRolesMixin):
    schematron = os.path.join(v2_0_0_SCH_DIR, 'v2-0-0_BRICR_SEED.sch')
    example_file = os.path.join(v2_0_0_SCH_DIR, 'examples', 'SEED_01.xml')

    def test_example_file_1_is_valid_with_info_messages(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.example_file)

        # -- Assert
        self.assert_failure_messages(failures, {})
