import os

from lxml import etree
import pytest

from tools.constants import BSYNC_NSMAP
from tools.validate_sch import validate_schematron

from conftest import failures_by_role, golden_tree, AssertFailureRolesMixin, SCH_DIR

class TestL100Audit(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'L100_Audit.sch')
    golden_file = os.path.join(SCH_DIR, 'golden_files', 'L100_Audit.xml')

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_roles(failures, {})
