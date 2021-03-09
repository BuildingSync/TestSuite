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

import os


from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, exemplary_tree, remove_element, v2_2_0_SCH_DIR


class TestL000PrelimAnalysis(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L000_Prelim_Analysis.sch')
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', 'L000_Prelim_Analysis.xml')

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_measured_scenario_missing(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the measured scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID',
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured]',
            ]
        })

    def test_fails_when_measured_scenario_not_linked_to_building(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the measured scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID',
            ]
        })

    def test_fails_when_benchmark_scenario_missing(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Scenario/auc:ScenarioType/auc:Benchmark')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID',
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Benchmark',
            ]
        })

    def test_fails_when_benchmark_scenario_not_linked_to_building(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                '/auc:BuildingSync/auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:Benchmark]/auc:LinkedPremises/auc:Building/auc:LinkedBuildingID'
            ]
        })

    def test_fails_when_no_address_or_climate_zone_type(self):
        # -- Setup
        tree = exemplary_tree('L000_Prelim_Analysis', 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the benchmark scenario
        tree = remove_element(tree, '//auc:Building/auc:Address')
        tree = remove_element(tree, '//auc:Building/auc:ClimateZoneType')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                'auc:ClimateZoneType/*/auc:ClimateZone or (auc:Address/auc:City and auc:Address/auc:State)'
            ]
        })
