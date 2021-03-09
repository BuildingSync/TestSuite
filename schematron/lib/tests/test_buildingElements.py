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

from lxml import etree
import pytest

from testsuite.validate_sch import validate_schematron
from schematron.conftest import AssertFailureRolesMixin, remove_element, sch_from_imported_pattern

DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')


class TestBuildingElements(AssertFailureRolesMixin):

    def test_be_L000BuildingInfo_passes_valid_doc(self):
        # -- Setup
        example_file = os.path.join(DATA_DIR, 'ex01.xml')
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.L000BuildingInfo")

        # -- Act
        failures = validate_schematron(schematron, example_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    @pytest.mark.parametrize("target_element,expected_message", [
        ('auc:PremisesName', "element 'auc:PremisesName' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:BuildingClassification', "element 'auc:BuildingClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:OccupancyClassification', "element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:YearOfConstruction', "element 'auc:YearOfConstruction' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
    ])
    def test_be_L000BuildingInfo_fails_when_missing_required_Building_element(self, target_element, expected_message):
        # -- Setup
        example_tree = etree.parse(os.path.join(DATA_DIR, 'ex01.xml'))
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.L000BuildingInfo")

        # make sure it's valid
        failures = validate_schematron(schematron, example_tree)

        # -- Act
        # remove the element
        remove_element(example_tree, f'//auc:Buildings/auc:Building/{target_element}')
        failures = validate_schematron(schematron, example_tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    def test_be_simpleLocationDetails_passes_valid_doc(self):
        # -- Setup
        example_file = os.path.join(DATA_DIR, 'ex01.xml')
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.simpleLocationDetails")

        # -- Act
        failures = validate_schematron(schematron, example_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    @pytest.mark.parametrize("target_element,expected_message", [
        ('auc:City', "element 'auc:City' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:State', "element 'auc:State' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:PostalCode', "element 'auc:PostalCode' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
        ('auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress', "element 'auc:StreetAddress' within element 'auc:Address/auc:StreetAddressDetail/auc:Simplified' is REQUIRED EXACTLY ONCE for: 'auc:Building'"),
    ])
    def test_be_simpleLocationDetails_fails_when_address_element_missing(self, target_element, expected_message):
        # -- Setup
        example_tree = etree.parse(os.path.join(DATA_DIR, 'ex01.xml'))
        schematron = sch_from_imported_pattern("buildingElements.sch", "be.simpleLocationDetails")

        # make sure it's valid
        failures = validate_schematron(schematron, example_tree)

        # -- Act
        # remove the element
        remove_element(example_tree, f'//auc:Buildings/auc:Building/auc:Address/{target_element}')
        failures = validate_schematron(schematron, example_tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })
