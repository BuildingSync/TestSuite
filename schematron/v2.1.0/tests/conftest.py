import copy
import os
import pprint

from lxml import etree

from tools.constants import BSYNC_NSMAP

SCH_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')


class AssertFailureRolesMixin:
    def assert_failure_counts(self, actual_failures, expected_dict):
        """Makes assertions about the failures. Specifically, their roles as well as
        what assertions they failed on

        :param actual_failures: list of Failures
        :param expected_dict: dict, keys are roles and values are the number of occurrences of that failure role
        """
        actual = failures_by_role(copy.deepcopy(actual_failures))
        expected = copy.deepcopy(expected_dict)
        for expected_role in list(expected.keys()):
            if expected[expected_role] != 0:
                assert expected_role in actual, f"Expected to find failure with role {expected_role}"
                actual_failures = actual.pop(expected_role)
                assert expected[expected_role] == len(actual_failures), f"Expected failures does not equal actual failures for role {expected_role}"
            else:
                assert expected_role not in actual, f"Expected to NOT find failure with role {expected_role}"

        assert len(actual) == 0, f"Expected to account for all failure roles, but found some unaccounted for:\n{pprint.pformat(actual, indent=4)}"

    def assert_failure_messages(self, actual_failures, expected_dict):
        """Makes assertions about the failures. Specifically, their roles as well as
        what the failed assertion messages were.

        :param actual_failures: list of Failures
        :param expected_dict: dict, keys are roles and values lists of assertion messages
        """
        actual = failures_by_role(copy.deepcopy(actual_failures))
        expected = copy.deepcopy(expected_dict)
        for expected_role in expected:
            if len(expected[expected_role]) != 0:
                assert expected_role in actual, f"Expected to find failure with role {expected_role}"
                actual_failure_msgs = [failure.message for failure in actual.pop(expected_role)]
                assert expected[expected_role] == actual_failure_msgs
            else:
                assert expected_role not in actual, f"Expected to NOT find failure with role {expected_role}"

        assert len(actual) == 0, f"Expected to account for all failure roles, but found some unaccounted for:\n{pprint.pformat(actual, indent=4)}"


def failures_by_role(failures):
    """Returns a dict of array of failures, keyed by failure role

    :param failures: list of Failures
    :return: dict
    """
    res = {}
    for failure in failures:
        if failure.role in res:
            res[failure.role].append(failure)
        else:
            res[failure.role] = [failure]

    return res


def exemplary_tree(name):
    """Returns parsed lxml tree of the exemplary file

    :param name: str, name of the file, without any file extension
    :return: lxml.etree
    """
    exemplary_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'exemplary_files', f'{name}.xml')
    return etree.parse(exemplary_file)


def remove_element(tree, xpath):
    elems = tree.xpath(xpath, namespaces=BSYNC_NSMAP)
    assert len(elems) == 1
    elem = elems[0]
    elem.getparent().remove(elem)

    return tree
