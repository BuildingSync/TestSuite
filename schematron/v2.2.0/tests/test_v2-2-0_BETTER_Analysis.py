import os

from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, v2_2_0_SCH_DIR


class TestBETTERAnalysis(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_BETTER_input.sch')
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', 'BETTER_input.xml')

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})
