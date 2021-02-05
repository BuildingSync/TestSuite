
from lxml import etree

from testsuite.constants import SCH_NSMAP, SCH_NS
from testsuite.generate_sch import make_pattern_for_testing_contexts, qname, add_assert_description


class TestMakePatternForStructure:
    def test_pattern_maker_simple(self):
        # -- Setup
        orig_pattern = {
            'title': 'My Pattern',
            'id': 'my_pattern',
            'see': '123',
            'rules': [
                {
                    'title': 'A',
                    # this is the part which should be expanded into new assertions
                    'context': '/a/b/c',
                    'generate_context_test': True,
                    # not necessary for test
                    'asserts': []
                }
            ]
        }

        # -- Act
        result = make_pattern_for_testing_contexts(orig_pattern)

        # -- Assert
        assert result['rules'] == [
            {
                'context': '/',
                'asserts': [{'test': '/a/b/c', 'description': '', 'role': 'ERROR'}],
                'variables': [],
            }
        ]

    def test_pattern_maker_multiple_rules(self):
        # -- Setup
        orig_pattern = {
            'title': 'My Pattern',
            'id': 'my_pattern',
            'see': '123',
            'rules': [
                {
                    'title': 'A',
                    'context': '/a/b/c',
                    'generate_context_test': True,
                },
                {
                    'title': 'B',
                    'context': '/d/e/f',
                    'generate_context_test': True,
                },
                {
                    'title': 'C',
                    'context': '/g/h/i',
                    'generate_context_test': True,
                }
            ]
        }

        # -- Act
        result = make_pattern_for_testing_contexts(orig_pattern)

        # -- Assert
        assert result['rules'] == [
            {
                'context': '/',
                'asserts': [
                    {'test': '/a/b/c', 'description': '', 'role': 'ERROR'},
                    {'test': '/d/e/f', 'description': '', 'role': 'ERROR'},
                    {'test': '/g/h/i', 'description': '', 'role': 'ERROR'}
                ],
                'variables': []
            }
        ]

    def test_pattern_maker_does_not_duplicate_contexts(self):
        # -- Setup
        orig_pattern = {
            'title': 'My Pattern',
            'id': 'my_pattern',
            'see': '123',
            'rules': [
                {
                    'title': 'A',
                    'context': '/a/b/c',
                    'generate_context_test': True,
                    'asserts': []
                },
                {
                    'title': 'B',
                    'context': '/a/b/c',
                    'generate_context_test': True,
                    'asserts': []
                }
            ]
        }

        # -- Act
        result = make_pattern_for_testing_contexts(orig_pattern)

        # -- Assert
        assert result['rules'] == [
            {
                'context': '/',
                'asserts': [{'test': '/a/b/c', 'description': '', 'role': 'ERROR'}],
                'variables': []
            }
        ]

    def test_pattern_maker_does_not_generate_tests_where_generate_context_test_is_false(self):
        # -- Setup
        orig_pattern = {
            'title': 'My Pattern',
            'id': 'my_pattern',
            'see': '123',
            'rules': [
                {
                    'title': 'A',
                    # this rule should NOT have a generated test
                    'context': '/a/b/c',
                    'generate_context_test': False,
                    'asserts': []
                },
                {
                    'title': 'B',
                    # this rule should have a generated test
                    'context': '/d/e/f',
                    'generate_context_test': True,
                    'asserts': []
                }
            ]
        }

        # -- Act
        result = make_pattern_for_testing_contexts(orig_pattern)

        # -- Assert
        assert result['rules'] == [
            {
                'context': '/',
                'asserts': [{'test': '/d/e/f', 'description': '', 'role': 'ERROR'}],
                'variables': [],
            }
        ]

    def test_add_assert_description_works_without_elements(self):
        # -- Setup
        assert_elem = etree.Element(qname('assert'), nsmap=SCH_NSMAP)
        description = 'hello world'

        # -- Act
        add_assert_description(assert_elem, description)

        # -- Assert
        expected_xml = f'<sch:assert xmlns:sch="{SCH_NS}">hello world</sch:assert>'
        assert expected_xml.encode() == etree.tostring(assert_elem, pretty_print=False)

    def test_add_assert_description_works_with_one_element(self):
        # -- Setup
        assert_elem = etree.Element(qname('assert'), nsmap=SCH_NSMAP)
        description = 'hello world <name/>'

        # -- Act
        add_assert_description(assert_elem, description)

        # -- Assert
        expected_xml = f'<sch:assert xmlns:sch="{SCH_NS}">hello world <sch:name/></sch:assert>'
        assert expected_xml.encode() == etree.tostring(assert_elem, pretty_print=False)

    def test_add_assert_description_works_with_multiple_elements(self):
        # -- Setup
        assert_elem = etree.Element(qname('assert'), nsmap=SCH_NSMAP)
        description = 'hello world <name/> more text <value-of select="abc/def/ghi"/> this > is escaped'

        # -- Act
        add_assert_description(assert_elem, description)

        # -- Assert
        expected_xml = f'<sch:assert xmlns:sch="{SCH_NS}">hello world <sch:name/> more text <sch:value-of select="abc/def/ghi"/> this &gt; is escaped</sch:assert>'
        assert expected_xml.encode() == etree.tostring(assert_elem, pretty_print=False)
