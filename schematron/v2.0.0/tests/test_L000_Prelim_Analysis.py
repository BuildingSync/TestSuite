import os

from lxml import etree

from tools.validate_sch import validate_schematron
from conftest import failures_by_role, AssertFailureRolesMixin

class TestL000PrelimAnalysis(AssertFailureRolesMixin):
    schematron = 'schematron/v2.0.0/L000_Prelim_Analysis.sch'
    golden_file = 'schematron/v2.0.0/golden_files/L000_Prelim_Analysis.xml'

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_roles(failures, {})
