from copy import deepcopy
import os


import pytest
from lxml import etree

from tools.constants import BSYNC_NSMAP, BSYNC_NS
from tools.validate_sch import validate_schematron

from schematron.conftest import AssertFailureRolesMixin, exemplary_tree, remove_element, replace_element, v2_2_0_SCH_DIR


class TestL100Audit(AssertFailureRolesMixin):
    schematron = os.path.join(v2_2_0_SCH_DIR, 'v2-2-0_L100_Audit.sch')
    exemplary_file = os.path.join(v2_2_0_SCH_DIR, 'exemplary_files', 'L100_Audit.xml')

    def test_exemplary_file_is_valid(self):
        # -- Act
        failures = validate_schematron(self.schematron, self.exemplary_file)

        # -- Assert
        self.assert_failure_messages(failures, {})

    def test_is_invalid_when_multiple_resource_uses_point_to_same_utility(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # duplicate one of the existing resource uses
        resource_use_xpath = '//auc:ResourceUses/auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]'
        orig_resource_use = tree.xpath(resource_use_xpath, namespaces=BSYNC_NSMAP)
        assert len(orig_resource_use) == 1
        orig_resource_use = orig_resource_use[0]
        copy_resource_use = deepcopy(orig_resource_use)
        resource_uses = orig_resource_use.getparent()
        resource_uses.insert(resource_uses.index(orig_resource_use), copy_resource_use)

        # make sure we duplicated successfully
        assert len(tree.xpath(resource_use_xpath, namespaces=BSYNC_NSMAP)) == 2, 'Expect there to be 2 duplicate ResourceUses'

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # only look at first failure as it's the one we should have caused
        # additional failures might be triggered b/c of downstream effects of
        # duplicating elements used for calculated values
        expected_message = 'Each auc:Utility should have exactly 1 auc:ResourceUse linked to it (ie not 0, not 2+)'
        assert expected_message == failures[0].message

    @pytest.mark.parametrize("target_element,expected_message", [
        ("auc:ApplicableStartDateForDemandRate",
         "auc:ApplicableStartDateForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:ApplicableEndDateForDemandRate",
         "auc:ApplicableEndDateForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:ElectricDemandRate",
         "auc:ElectricDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity")])
    def test_is_invalid_when_elec_utility_flat_rate_is_missing_elec_specific_requirements(self, target_element, expected_message):
        """Test that the electricity-specific RatePeriod requirements for FlatRate RateSchedule are working"""
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # remove the electricity specific required element
        xpath = '//auc:Utilities/auc:Utility[@ID = //auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]/auc:UtilityIDs/auc:UtilityID/@IDref]' \
                f'/auc:RateSchedules/auc:RateSchedule/auc:TypeOfRateStructure/auc:FlatRate/auc:RatePeriods/auc:RatePeriod/{target_element}'
        remove_element(tree, xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("target_element,expected_message", [
        ("auc:ApplicableStartDateForDemandRate",
         "auc:ApplicableStartDateForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:ApplicableEndDateForDemandRate",
         "auc:ApplicableEndDateForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:TimeOfUsePeriods/auc:TimeOfUsePeriod[1]/auc:ApplicableStartTimeForDemandRate",
         "auc:ApplicableStartTimeForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:TimeOfUsePeriods/auc:TimeOfUsePeriod[1]/auc:ApplicableEndTimeForDemandRate",
         "auc:ApplicableEndTimeForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:TimeOfUsePeriods/auc:TimeOfUsePeriod[1]/auc:ElectricDemandRate",
         "auc:ElectricDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity")])
    def test_is_invalid_when_elec_utility_time_of_use_rate_is_missing_elec_specific_requirements(self, target_element, expected_message):
        """Test that the electricity-specific RatePeriod requirements for TimeOfUse RateSchedule are working"""
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace the existing rate schedule with a valid TimeOfUseRate schedule
        valid_tou_rate_raw = f'''
        <auc:TimeOfUseRate xmlns:auc="{BSYNC_NS}">
            <auc:RatePeriods>
                <auc:RatePeriod>
                    <auc:ApplicableStartDateForEnergyRate>--01-01</auc:ApplicableStartDateForEnergyRate>
                    <auc:ApplicableEndDateForEnergyRate>--01-01</auc:ApplicableEndDateForEnergyRate>
                    <auc:ApplicableStartDateForDemandRate>--01-01</auc:ApplicableStartDateForDemandRate>
                    <auc:ApplicableEndDateForDemandRate>--01-01</auc:ApplicableEndDateForDemandRate>
                    <auc:TimeOfUsePeriods>
                        <auc:TimeOfUsePeriod>
                            <auc:ApplicableStartTimeForEnergyRate>00:00:00</auc:ApplicableStartTimeForEnergyRate>
                            <auc:ApplicableEndTimeForEnergyRate>12:00:00</auc:ApplicableEndTimeForEnergyRate>
                            <auc:ApplicableStartTimeForDemandRate>00:00:00</auc:ApplicableStartTimeForDemandRate>
                            <auc:ApplicableEndTimeForDemandRate>12:00:00</auc:ApplicableEndTimeForDemandRate>
                            <auc:EnergyCostRate>123</auc:EnergyCostRate>
                            <auc:ElectricDemandRate>123</auc:ElectricDemandRate>
                        </auc:TimeOfUsePeriod>
                        <auc:TimeOfUsePeriod>
                            <auc:ApplicableStartTimeForEnergyRate>12:00:00</auc:ApplicableStartTimeForEnergyRate>
                            <auc:ApplicableEndTimeForEnergyRate>24:00:00</auc:ApplicableEndTimeForEnergyRate>
                            <auc:ApplicableStartTimeForDemandRate>00:00:00</auc:ApplicableStartTimeForDemandRate>
                            <auc:ApplicableEndTimeForDemandRate>12:00:00</auc:ApplicableEndTimeForDemandRate>
                            <auc:EnergyCostRate>123</auc:EnergyCostRate>
                            <auc:ElectricDemandRate>123</auc:ElectricDemandRate>
                        </auc:TimeOfUsePeriod>
                    </auc:TimeOfUsePeriods>
                </auc:RatePeriod>
            </auc:RatePeriods>
        </auc:TimeOfUseRate>
        '''
        valid_tou_rate_elem = etree.fromstring(valid_tou_rate_raw)
        xpath_to_replace = '//auc:Utilities/auc:Utility[@ID = //auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]/auc:UtilityIDs/auc:UtilityID/@IDref]' \
                           '/auc:RateSchedules/auc:RateSchedule/auc:TypeOfRateStructure/auc:FlatRate'
        replace_element(tree, xpath_to_replace, valid_tou_rate_elem)

        # verify updated tree is valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # finally, remove the target element to invalidate the document
        xpath = '//auc:Utilities/auc:Utility[@ID = //auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]/auc:UtilityIDs/auc:UtilityID/@IDref]' \
                f'/auc:RateSchedules/auc:RateSchedule/auc:TypeOfRateStructure/auc:TimeOfUseRate/auc:RatePeriods/auc:RatePeriod/{target_element}'
        remove_element(tree, xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    @pytest.mark.parametrize("target_element,expected_message", [
        ("auc:ApplicableStartDateForDemandRate",
         "auc:ApplicableStartDateForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:ApplicableEndDateForDemandRate",
         "auc:ApplicableEndDateForDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:RateTiers/auc:RateTier[1]/auc:MaxkWUsage",
         "auc:MaxkWUsage must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:RateTiers/auc:RateTier[1]/auc:ElectricDemandRate",
         "auc:ElectricDemandRate must be defined if the parent auc:Utility's linked resource is of type Electricity"),
        ("auc:RateTiers/auc:RateTier[1]/auc:DemandWindow",
         "auc:DemandWindow must be defined if the parent auc:Utility's linked resource is of type Electricity")])
    def test_is_invalid_when_elec_utility_tiered_rate_is_missing_elec_specific_requirements(self, target_element, expected_message):
        """Test that the electricity-specific RatePeriod requirements for TieredRates RateSchedule are working"""
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace the existing rate schedule with a valid TieredRates schedule
        valid_tiered_raw = f'''
        <auc:TieredRates xmlns:auc="{BSYNC_NS}">
            <auc:TieredRate>
                <auc:RatePeriods>
                    <auc:RatePeriod>
                        <auc:ApplicableStartDateForEnergyRate>--01-01</auc:ApplicableStartDateForEnergyRate>
                        <auc:ApplicableEndDateForEnergyRate>--01-01</auc:ApplicableEndDateForEnergyRate>
                        <auc:ApplicableStartDateForDemandRate>--01-01</auc:ApplicableStartDateForDemandRate>
                        <auc:ApplicableEndDateForDemandRate>--01-01</auc:ApplicableEndDateForDemandRate>
                        <auc:RateTiers>
                            <auc:RateTier>
                                <auc:MaxkWhUsage>123</auc:MaxkWhUsage>
                                <auc:MaxkWUsage>123</auc:MaxkWUsage>
                                <auc:EnergyCostRate>123</auc:EnergyCostRate>
                                <auc:ElectricDemandRate>123</auc:ElectricDemandRate>
                                <auc:DemandWindow>123</auc:DemandWindow>
                            </auc:RateTier>
                            <auc:RateTier>
                                <auc:MaxkWhUsage>123</auc:MaxkWhUsage>
                                <auc:MaxkWUsage>123</auc:MaxkWUsage>
                                <auc:EnergyCostRate>123</auc:EnergyCostRate>
                                <auc:ElectricDemandRate>123</auc:ElectricDemandRate>
                                <auc:DemandWindow>123</auc:DemandWindow>
                            </auc:RateTier>
                        </auc:RateTiers>
                    </auc:RatePeriod>
                </auc:RatePeriods>
            </auc:TieredRate>
        </auc:TieredRates>
        '''
        valid_tiered_raw = etree.fromstring(valid_tiered_raw)
        xpath_to_replace = '//auc:Utilities/auc:Utility[@ID = //auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]/auc:UtilityIDs/auc:UtilityID/@IDref]' \
                           '/auc:RateSchedules/auc:RateSchedule/auc:TypeOfRateStructure/auc:FlatRate'
        replace_element(tree, xpath_to_replace, valid_tiered_raw)

        # verify updated tree is valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # finally, remove the target element to invalidate the document
        xpath = '//auc:Utilities/auc:Utility[@ID = //auc:ResourceUse[auc:EnergyResource/text() = "Electricity"]/auc:UtilityIDs/auc:UtilityID/@IDref]' \
                f'/auc:RateSchedules/auc:RateSchedule/auc:TypeOfRateStructure/auc:TieredRates/auc:TieredRate/auc:RatePeriods/auc:RatePeriod/{target_element}'
        remove_element(tree, xpath)

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [expected_message]
        })

    def test_is_invalid_when_site_energy_use_is_wrong(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace SiteEnergyUse with a bad value
        elem = tree.xpath('//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding]/auc:AllResourceTotals/auc:AllResourceTotal/auc:SiteEnergyUse', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        correct_value = elem.text
        bad_value = '12345'
        elem.text = bad_value

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # first failure should be the error message
        # note that we only check this one, but changing SiteEnergyUse will break
        # other calculation checks as well (e.g. SiteEnergyUseIntensity)
        assert failures[0].message == f'auc:SiteEnergyUse (which is {bad_value}) should equal auc:ImportedEnergyConsistentUnits - auc:ExportedEnergyConsistentUnits - auc:NetIncreaseInStoredEnergyConsistentUnits (which is {correct_value})'

    def test_is_invalid_when_site_energy_use_intensity_is_wrong(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace SiteEnergyUse with a bad value
        elem = tree.xpath('//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding]/auc:AllResourceTotals/auc:AllResourceTotal/auc:SiteEnergyUseIntensity', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        correct_site_eui = '31.0559796437659'
        bad_value = '45'
        difference = '13.9440203562341'
        difference_allowable = '2.25'
        elem.text = bad_value

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [f'auc:SiteEnergyUseIntensity (which is {bad_value}) should approximately equal auc:SiteEnergyUse divided by the auc:Building\'s Gross floor area (which is {correct_site_eui}); the difference, {difference} is too large (should be less than {difference_allowable})']
        })

    def test_is_invalid_when_building_energy_use_is_wrong(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace BuildingEnergyUse with a bad value
        elem = tree.xpath('//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding]/auc:AllResourceTotals/auc:AllResourceTotal/auc:BuildingEnergyUse', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        correct_value = elem.text
        bad_value = '12345'
        elem.text = bad_value

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # first failure should be the error message
        # note that we only check this one, but changing BuildingEnergyUse will break
        # other calculation checks as well (e.g. BuildingEnergyUseIntensity)
        assert failures[0].message == f'auc:BuildingEnergyUse (which is {bad_value}) should equal auc:ImportedEnergyConsistentUnits + auc:OnsiteEnergyProductionConsistentUnits - auc:ExportedEnergyConsistentUnits - auc:NetIncreaseInStoredEnergyConsistentUnits (which is {correct_value})'

    def test_is_invalid_when_building_energy_use_intensity_is_wrong(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace BuildingEnergyUse with a bad value
        elem = tree.xpath('//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding]/auc:AllResourceTotals/auc:AllResourceTotal/auc:BuildingEnergyUseIntensity', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        correct_building_eui = '34.7291893856779'
        bad_value = '40'
        difference = '5.270810614322066'
        difference_allowable = '1.553'
        elem.text = bad_value

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [f'auc:BuildingEnergyUseIntensity (which is {bad_value}) should approximately equal auc:BuildingEnergyUse divided by the auc:Building\'s Gross floor area (which is {correct_building_eui}); the difference, {difference} is too large (should be less than {difference_allowable})']
        })

    def test_is_invalid_when_onsite_energy_production_is_wrong(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace OnsiteEnergyProductionConsistentUnits with a bad value
        elem = tree.xpath('//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding]/auc:AllResourceTotals/auc:AllResourceTotal/auc:OnsiteEnergyProductionConsistentUnits', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        correct_value = elem.text
        bad_value = '12345'
        elem.text = bad_value

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # first failure should be the error message
        # note that we only check this one, but changing this element will break
        # other calculated values
        expected_message = f'auc:OnsiteEnergyProductionConsistentUnits (which is {bad_value}) should equal the sum of all auc:AnnualFuelUseConsistentUnits for auc:ResourceUses that are generated (which is {correct_value})'
        assert expected_message == failures[0].message

    def test_is_invalid_when_exported_energy_is_wrong(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # replace ExportedEnergyConsistentUnits with a bad value
        elem = tree.xpath('//auc:Scenario[auc:ScenarioType/auc:CurrentBuilding]/auc:AllResourceTotals/auc:AllResourceTotal/auc:ExportedEnergyConsistentUnits', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        correct_value = elem.text
        bad_value = '12345'
        elem.text = bad_value

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        # first failure should be the error message
        # note that we only check this one, but changing this element will break
        # other calculated values
        expected_message = f'auc:ExportedEnergyConsistentUnits (which is {bad_value}) should equal the sum of all auc:AnnualFuelUseConsistentUnits for auc:ResourceUses that are exported (which is {correct_value})'
        assert expected_message == failures[0].message

    def test_is_invalid_when_residential_and_no_spatial_units(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # verify classification is Mixed use commercial or Residential
        elem = tree.xpath('//auc:Buildings/auc:Building/auc:BuildingClassification', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        assert elem.text in ['Mixed use commercial', 'Residential']
        # remove spatial units
        remove_element(tree, '//auc:Building/auc:SpatialUnits')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {
            'ERROR': [
                "If BuildingClassification implies residents (Mixed use commercial or Residential), number of apartments units must be defined at auc:SpatialUnits/auc:SpatialUnit[auc:SpatialUnitType = 'Apartment units']/auc:NumberOfUnits.",
                "If BuildingClassification implies residents (Mixed use commercial or Residential), the percentage occupied must be defined at auc:SpatialUnits/auc:SpatialUnit[auc:SpatialUnitType = 'Apartment units']/auc:SpatialUnitOccupiedPercentage.",
            ]
        })

    def test_is_valid_when_not_residential_and_no_spatial_units(self):
        # -- Setup
        tree = exemplary_tree('L100_Audit', 'v2.2.0')

        # make sure it's valid
        failures = validate_schematron(self.schematron, tree)
        self.assert_failure_messages(failures, {})

        # change BuildingClassification
        elem = tree.xpath('//auc:Buildings/auc:Building/auc:BuildingClassification', namespaces=BSYNC_NSMAP)
        assert len(elem) == 1
        elem = elem[0]
        elem.text = 'Commercial'
        # remove spatial units
        remove_element(tree, '//auc:Building/auc:SpatialUnits')

        # -- Act
        failures = validate_schematron(self.schematron, tree)

        # -- Assert
        self.assert_failure_messages(failures, {})
