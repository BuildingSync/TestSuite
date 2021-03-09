"""
*********************************************************************************************************
:copyright (c) BuildingSync®, Copyright (c) 2015-2021, Alliance for Sustainable Energy, LLC,
and other contributors.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

(1) Redistributions of source code must retain the above copyright notice, this list of conditions
and the following disclaimer.

(2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions
and the following disclaimer in the documentation and/or other materials provided with the distribution.

(3) Neither the name of the copyright holder nor the names of any contributors may be used to endorse
or promote products derived from this software without specific prior written permission from the
respective party.

(4) Other than as required in clauses (1) and (2), distributions in any form of modifications or other
derivative works may not use the "BuildingSync" trademark or any other confusingly similar designation
without specific prior written permission from Alliance for Sustainable Energy, LLC.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) AND ANY CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER(S), ANY
CONTRIBUTORS, THE UNITED STATES GOVERNMENT, OR THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF
THEIR EMPLOYEES, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*********************************************************************************************************
"""


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
