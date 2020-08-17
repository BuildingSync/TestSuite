import os
import sys

from lxml import etree
import pytest

from tools.generate_sch import make_pattern_for_testing_contexts

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
                'asserts': [{'test': '/a/b/c', 'description': '', 'role': 'ERROR'}]
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
                },
                {
                    'title': 'B',
                    'context': '/d/e/f',
                },
                {
                    'title': 'C',
                    'context': '/g/h/i',
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
                ]
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
                    'asserts': []
                },
                {
                    'title': 'B',
                    'context': '/a/b/c',
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
                'asserts': [{'test': '/a/b/c', 'description': '', 'role': 'ERROR'}]
            }
        ]
