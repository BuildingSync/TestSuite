import os

import pytest

from testsuite.validate_sch import validate_schematron


@pytest.fixture
def simple_valid_doc_content():
    return '''<root>
        <child attr="hello"/>
    </root>'''


@pytest.fixture
def simple_bad_doc_content():
    return '''<root>
        <child attr="world"/>
    </root>'''


@pytest.fixture
def simple_sch_content():
    return '''
    <sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
        <sch:pattern>
            <sch:rule context="/root/child">
                <sch:assert test="@attr = 'hello'" role="ERROR">Attr should be hello</sch:assert>
            </sch:rule>
        </sch:pattern>
    </sch:schema>'''


class TestValidateSchematron:
    def test_when_doc_is_valid_returns_no_errors(self, simple_valid_doc_content, simple_sch_content):
        # -- Act
        failures = validate_schematron(simple_sch_content, simple_valid_doc_content)

        # -- Assert
        assert len(failures) == 0

    def test_accepts_file_path(self, tmpdir, simple_valid_doc_content, simple_sch_content):
        # -- Setup
        doc = os.path.join(tmpdir, "test.xml")
        with open(doc, 'w') as f:
            f.write(simple_valid_doc_content)
        sch = os.path.join(tmpdir, "test.sch")
        with open(sch, 'w') as f:
            f.write(simple_sch_content)

        # -- Act
        failures = validate_schematron(sch, doc)

        # -- Assert
        assert len(failures) == 0

    def test_when_doc_is_bad_returns_errors(self, simple_bad_doc_content, simple_sch_content):
        # -- Act
        failures = validate_schematron(simple_sch_content, simple_bad_doc_content)

        # -- Assert
        assert len(failures) == 1
        failure = failures[0]
        assert failure.line == 2
        assert failure.element == 'child'
        assert failure.message == 'Attr should be hello'
        assert failure.role == 'ERROR'

    def test_when_phase_is_unspecified_it_runs_all_phases(self):
        # -- Setup
        doc = '''<root>
            <child attr="world"/>
        </root>'''
        # create sch that uses phases - each of which should fail against the document
        sch = '''<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:phase id="phaseA">
                <sch:active pattern="patternA"/>
            </sch:phase>
            <sch:phase id="phaseB">
                <sch:active pattern="patternB"/>
            </sch:phase>
            <sch:pattern id="patternA">
                <sch:rule context="/root/child">
                    <sch:assert test="@attr = 'hello'" role="ERROR">Attr should be hello</sch:assert>
                </sch:rule>
            </sch:pattern>
            <sch:pattern id="patternB">
                <sch:rule context="/root">
                    <sch:assert test="count(child) = 123" role="ERROR">There should be 123 child elements</sch:assert>
                </sch:rule>
            </sch:pattern>
        </sch:schema>'''

        # -- Act
        failures = validate_schematron(sch, doc)

        # -- Assert
        assert len(failures) == 2

    def test_when_phase_is_specified_it_runs_only_that_phase(self):
        # -- Setup
        doc = '''<root>
            <child attr="world"/>
        </root>'''
        # create sch that uses phases - each of which should fail against the document
        sch = '''<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:phase id="phaseA">
                <sch:active pattern="patternA"/>
            </sch:phase>
            <sch:phase id="phaseB">
                <sch:active pattern="patternB"/>
            </sch:phase>
            <sch:pattern id="patternA">
                <sch:rule context="/root/child">
                    <sch:assert test="@attr = 'hello'" role="ERROR">Attr should be hello</sch:assert>
                </sch:rule>
            </sch:pattern>
            <sch:pattern id="patternB">
                <sch:rule context="/root">
                    <sch:assert test="count(child) = 123" role="ERROR">There should be 123 child elements</sch:assert>
                </sch:rule>
            </sch:pattern>
        </sch:schema>'''

        # -- Act
        # note that we are passing a phase ID in order to only run that one
        failures = validate_schematron(sch, doc, phase="phaseA", strict_context=False)

        # -- Assert
        # there should only be one failure b/c we only ran one phase
        assert len(failures) == 1
        assert failures[0].message == 'Attr should be hello'

    def test_when_phase_is_specified_and_using_strict_context_it_ignores_rules_in_phases_not_run(self):
        # -- Setup
        doc = '''<root>
            <child attr="world"/>
        </root>'''
        # create sch that uses phases - each of which should fail against the document
        sch = '''<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:phase id="phaseA">
                <sch:active pattern="patternA"/>
            </sch:phase>
            <sch:phase id="phaseB">
                <sch:active pattern="patternB"/>
            </sch:phase>
            <sch:pattern id="patternA">
                <sch:rule context="/root/child">
                    <sch:assert test="@attr = 'hello'" role="ERROR">Attr should be hello</sch:assert>
                </sch:rule>
            </sch:pattern>
            <sch:pattern id="patternB">
                <sch:rule context="/root">
                    <sch:assert test="count(child) = 123" role="ERROR">There should be 123 child elements</sch:assert>
                </sch:rule>
            </sch:pattern>
        </sch:schema>'''

        # -- Act
        # note that we are passing a phase ID in order to only run that one
        failures = validate_schematron(sch, doc, phase="phaseA", strict_context=True)

        # -- Assert
        # there should only be one failure b/c we only ran one phase
        assert len(failures) == 1
        assert failures[0].message == 'Attr should be hello'

    def test_when_phase_is_specified_and_it_does_not_exist_validation_fails(self):
        # -- Setup
        doc = '''<root>
            <child attr="world"/>
        </root>'''
        # create sch that uses phases - each of which should fail against the document
        sch = '''<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:phase id="phaseA">
                <sch:active pattern="patternA"/>
            </sch:phase>
            <sch:pattern id="patternA">
                <sch:rule context="/root/child">
                    <sch:assert test="@attr = 'hello'" role="ERROR">Attr should be hello</sch:assert>
                </sch:rule>
            </sch:pattern>
        </sch:schema>'''

        # -- Act, Assert
        with pytest.raises(Exception):
            validate_schematron(sch, doc, phase='bogus_phase_id')

    def test_when_using_strict_context_it_returns_failures_for_unfired_rules(self):
        # -- Setup
        doc = '''<root>
            <child attr="hello"/>
        </root>'''
        # first pattern should fire and pass
        # second pattern should _not_fire, and with strict validation result in a failure
        sch = '''<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
            <sch:pattern id="patternA">
                <sch:rule context="/root/child">
                    <sch:assert test="@attr = 'hello'" role="ERROR">Attr should be hello</sch:assert>
                </sch:rule>
            </sch:pattern>
            <sch:pattern id="patternB">
                <sch:rule context="/root/bogus">
                    <sch:assert test="count(fake) = 123" role="ERROR">There should be 123 fake elements</sch:assert>
                </sch:rule>
            </sch:pattern>
        </sch:schema>'''

        # -- Act
        failures = validate_schematron(sch, doc, strict_context=True)

        # -- Assert
        # there should be one failure, the rule which was not fired
        assert len(failures) == 1
        assert failures[0].message == 'Rule was NOT used for validation: /root/bogus'
