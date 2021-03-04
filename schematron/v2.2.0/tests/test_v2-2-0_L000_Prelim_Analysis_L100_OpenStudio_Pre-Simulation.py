import os

from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, v2_2_0_SCH_DIR

class TestL000AuditL100Simulation(AssertFailureRolesMixin):
    schematron1 = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L000_Prelim_Analysis.sch')
    schematron2 = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L100_OpenStudio_Pre-Simulation.sch')
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', 'L000_Audit_L100_Simulation.xml')

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron1, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

        # -- Act
        failures = validate_schematron(self.schematron2, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

 