import os

import pytest

from tools.validate_sch import validate_schematron

def failures_by_role(failures):
    res = {}
    for failure in failures:
        if failure.role in res:
            res[failure.role].append(failure)
        else:
            res[failure.role] = [failure]

    return res

class TestL000PrelimAnalysis:
    schematron = 'schematron/v2.0.0/L000_Prelim_Analysis.sch'
    golden_file = 'schematron/v2.0.0/golden_files/L000_Prelim_Analysis.xml'

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        mapped_failures = failures_by_role(failures)
        assert len(mapped_failures.pop('ERROR', [])) == 0
        assert len(mapped_failures.pop('INFO', [])) == 0
        assert len(mapped_failures.pop('WARNING', [])) == 0
        assert len(mapped_failures) == 0, "unexpected role(s) for failure"
