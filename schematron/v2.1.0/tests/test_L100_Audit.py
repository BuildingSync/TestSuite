import os


from tools.validate_sch import validate_schematron

from conftest import AssertFailureRolesMixin, SCH_DIR, golden_tree, remove_element


class TestL100Audit(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'L100_Audit.sch')
    golden_file = os.path.join(SCH_DIR, 'golden_files', 'L100_Audit.xml')

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_counts(failures, {})

    def test_is_valid_when_only_resource_use_is_electricity(self):
        # -- Setup
        tree = golden_tree('L100_Audit')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_counts(failures, {})

        # remove any resource uses that aren't electricity
        remove_element(tree, '//auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() != "Electricity"]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_counts(failures, {})

    def test_is_invalid_when_only_resource_use_is_not_electricity(self):
        # -- Setup
        tree = golden_tree('L100_Audit')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_counts(failures, {})

        # remove any resource uses that are electricity
        remove_element(tree, '//auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        assert len(failures) > 0, f'Expected failures, got: {failures}'
