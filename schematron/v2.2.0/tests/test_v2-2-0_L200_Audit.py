import os


from tools.constants import BSYNC_NSMAP
from tools.validate_sch import validate_schematron

from schematron.conftest import AssertFailureRolesMixin, v2_2_0_SCH_DIR, exemplary_tree


class TestL200Audit(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L200_Audit.sch')
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', 'L200_Audit.xml')

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_is_invalid_when_schedule_types_differ_inside_schedule_details(self):
        # -- Setup
        tree = exemplary_tree('L200_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace a ScheduleCategory with something that will be different from
        # the other ScheduleCategories
        elem = tree.xpath('//auc:Schedules/auc:Schedule[1]/auc:ScheduleDetails[1]/auc:ScheduleDetail[1]/auc:ScheduleCategory', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        elem.text = 'Bogus Category'

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': ['All auc:ScheduleDetail within an auc:ScheduleDetails should have the same auc:ScheduleCategory']
        })
