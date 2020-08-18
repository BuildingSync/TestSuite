from copy import deepcopy
import os


from tools.constants import BSYNC_NSMAP
from tools.validate_sch import validate_schematron

from conftest import AssertFailureRolesMixin, SCH_DIR, golden_tree, remove_element


class TestL100Audit(AssertFailureRolesMixin):
    schematron = os.path.join(SCH_DIR, 'L100_Audit.sch')
    golden_file = os.path.join(SCH_DIR, 'golden_files', 'L100_Audit.xml')

    def test_golden_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.golden_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_is_valid_when_only_resource_use_is_electricity(self):
        # -- Setup
        tree = golden_tree('L100_Audit')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove any resource uses that aren't electricity (and their linked utilities)
        remove_element(tree, '//auc:Utility[@ID = //auc:ResourceUse[auc:EnergyResource/text() != "Electricity"]/auc:UtilityIDs/auc:UtilityID/@IDref]')
        remove_element(tree, '//auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() != "Electricity"]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_is_invalid_when_only_resource_use_is_not_electricity(self):
        # -- Setup
        tree = golden_tree('L100_Audit')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove any resource uses that are electricity (as well as it's linked auc:Utility)
        remove_element(tree, '//auc:Utility[@ID = //auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]/auc:UtilityIDs/auc:UtilityID/@IDref]')
        remove_element(tree, '//auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['There must be at least one Electricity ResourceUse']
        })

    def test_is_invalid_when_multiple_resource_uses_point_to_same_utility(self):
        # -- Setup
        tree = golden_tree('L100_Audit')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # duplicate one of the existing resource uses
        resource_use_xpath = '//auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]'
        orig_resource_use = tree.xpath(resource_use_xpath, namespaces=BSYNC_NSMAP)
        assert len(orig_resource_use) == 1
        orig_resource_use = orig_resource_use[0]
        copy_resource_use = deepcopy(orig_resource_use)
        resource_uses = orig_resource_use.getparent()
        resource_uses.insert(resource_uses.index(orig_resource_use), copy_resource_use)

        # make sure we duplicated successfully
        assert len(tree.xpath(resource_use_xpath, namespaces=BSYNC_NSMAP)) == 2, 'Expect there to be 2 duplicate ResourceUses'

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['Each auc:Utility should have exactly 1 auc:ResourceUse linked to it (ie not 0, not 2+)']
        })
