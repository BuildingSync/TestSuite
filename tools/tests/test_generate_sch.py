

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
                'asserts': [{'test': '/a/b/c', 'description': '', 'role': 'ERROR'}]
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
                'asserts': [{'test': '/d/e/f', 'description': '', 'role': 'ERROR'}]
            }
        ]
