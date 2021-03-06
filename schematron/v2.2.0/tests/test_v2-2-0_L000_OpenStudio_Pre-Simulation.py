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

from testsuite.constants import BSYNC_NSMAP
from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, exemplary_tree, remove_element, v2_2_0_SCH_DIR


class TestL000OpenStudioSimulation01(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L000_OpenStudio_Pre-Simulation.sch')
    exemplary_file_name = 'L000_OpenStudio_Pre-Simulation_01'
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', f"{exemplary_file_name}.xml")

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_no_address(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the address
        tree = remove_element(tree, '//auc:Building/auc:Address')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                'auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)'
            ]})

    def test_fails_when_baseline_scenario_missing(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        scenario_xpath = '//auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus/text()="Not Started"]'
        scenario_element = tree.xpath(scenario_xpath, namespaces=BSYNC_NSMAP)
        assert len(scenario_element) == 1

        # remove the scenario
        tree = remove_element(tree, scenario_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # Only worry about the first failure
        failures = [failures[0]]
        self.assert_failure_messages(failures, {
            'ERROR': [
                'An auc:Building should be linked to an auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus]'
            ]
        })

    def test_fails_when_scenario_missing_linked_building(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        scenario_linked_building_xpath = '//auc:Scenarios/auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus/text()="Not Started"]/auc:LinkedPremises/auc:Building'
        scenario_element = tree.xpath(scenario_linked_building_xpath, namespaces=BSYNC_NSMAP)
        assert len(scenario_element) == 1

        # remove the building
        tree = remove_element(tree, scenario_linked_building_xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                'An auc:Building should be linked to an auc:Scenario[auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Modeled/auc:SimulationCompletionStatus]',
                'All Scenarios should be linked to a Building'
            ]
        })


class TestL000OpenStudioSimulation02(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L000_OpenStudio_Pre-Simulation.sch')
    exemplary_file_name = 'L000_OpenStudio_Pre-Simulation_02'
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', f"{exemplary_file_name}.xml")

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_fails_when_no_climate_zone_type(self):
        # -- Setup
        tree = exemplary_tree(self.exemplary_file_name, 'v2.2.0')

        # verify it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the climate zone
        tree = remove_element(tree, '//auc:Building/auc:ClimateZoneType')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                'auc:Address or auc:ClimateZoneType or auc:WeatherDataStationID or (auc:Latitude and auc:Longitude)'
            ]
        })
