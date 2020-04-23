require 'spec_helper'
require 'schematron-nokogiri'

# sc.be.hasBenchmarkType
describe 'A PROPER sc.be.hasBenchmarkType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_building_has_benchmark_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should ensure every auc:Building is linked to a auc:Scenario/auc:ScenarioType/auc:Benchmark" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'An IMPROPER sc.be.hasBenchmarkType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_building_has_benchmark_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @buildings_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings'
    @benchmark_scenario = 'auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Benchmark'
  end

  it "Should issue one ERROR for every auc:Building that is not linked to a auc:Scenario/auc:ScenarioType/auc:Benchmark.  Works even if Building does not have ID attribute." do
    doc = @doc_original.clone
    buildings = doc.root.xpath(@buildings_string)
    Nokogiri::XML::Builder.with(buildings[0]) do |xml|
      xml['auc'].Building
    end
    # puts doc
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Building' ID = '' IS REQUIRED TO BE LINKED TO an 'auc:Scenario/auc:ScenarioType/auc:Benchmark'")
  end

  it "Should issue one ERROR for every auc:Building if the auc:Benchmark element is removed from auc:Scenario/auc:ScenarioType." do
    doc = @doc_original.clone
    scenario_type_benchmark = doc.root.xpath(@benchmark_scenario)
    expect(scenario_type_benchmark.length).to eq(1)
    scenario_type_benchmark.each(&:remove)
    # puts doc
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Building' ID = 'Willis_Tower' IS REQUIRED TO BE LINKED TO an 'auc:Scenario/auc:ScenarioType/auc:Benchmark'")
  end
end

# sc.be.hasMeasured
describe 'A PROPER sc.be.hasMeasured' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_building_has_measured.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should ensure every auc:Building is linked to a auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'An IMPROPER sc.be.hasMeasured' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_building_has_measured.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @buildings_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings'
    @measured_scenario = 'auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured'
  end

  it "Should issue one ERROR for every auc:Building that is not linked to an auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured.  Works even if Building does not have ID attribute." do
    doc = @doc_original.clone
    buildings = doc.root.xpath(@buildings_string)
    Nokogiri::XML::Builder.with(buildings[0]) do |xml|
      xml['auc'].Building
    end
    # puts doc
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Building' ID = '' IS REQUIRED TO BE LINKED TO an 'auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured'")
  end

  it "Should issue one ERROR for every auc:Building if auc:Measured element is removed from under the auc:ScenarioType." do
    doc = @doc_original.clone
    scenario_type_measured = doc.root.xpath(@measured_scenario)
    expect(scenario_type_measured.length).to eq(1)
    scenario_type_measured.each(&:remove)

    # puts doc
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Building' ID = 'Willis_Tower' IS REQUIRED TO BE LINKED TO an 'auc:Scenario/auc:ScenarioType/auc:CurrentBuilding/auc:CalculationMethod/auc:Measured'")
  end
end

# sc.benchmarkType.mainDetails.L000
describe 'A PROPER sc.benchmarkType.mainDetails.L000' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_benchmark_type_main_details_L000.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should ensure every auc:ScenarioType/auc:Benchmark has the following:
      - auc:BenchmarkTool
      - auc:BenchmarkYear
      - auc:BenchmarkValue
      - ../../auc:LinkedPremises/auc:Building/auc:LinkedBuildingID" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'An IMPROPER sc.benchmarkType.mainDetails.L000' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_benchmark_type_main_details_L000.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @buildings_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings'
    @benchmark_scenario = 'auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios/auc:Scenario/auc:ScenarioType/auc:Benchmark'
  end

  it "Should issue one ERROR if no child element exists for auc:BenchmarkType" do
    doc = @doc_original.clone
    benchmark_benchmark_type_cbecs = doc.root.xpath(@benchmark_scenario + "/auc:BenchmarkType/auc:CBECS")
    expect(benchmark_benchmark_type_cbecs.length).to eq(1)
    benchmark_benchmark_type_cbecs.each(&:remove)

    # puts doc
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] child element for 'auc:BenchmarkType' is REQUIRED AT LEAST ONCE for 'auc:Benchmark’")
  end

  it "Should issue one ERROR if the auc:Benchmark/auc:BenchmarkTool element is not specified" do
    doc = @doc_original.clone
    benchmark_benchmark_tool = doc.root.xpath(@benchmark_scenario + "/auc:BenchmarkTool")
    expect(benchmark_benchmark_tool.length).to eq(1)
    benchmark_benchmark_tool.each(&:remove)

    # puts doc
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:BenchmarkTool' is REQUIRED EXACTLY ONCE for 'auc:Benchmark’")
  end

  it "Should issue one ERROR if the auc:Benchmark/auc:BenchmarkYear element is not specified" do
    doc = @doc_original.clone
    benchmark_benchmark_year = doc.root.xpath(@benchmark_scenario + '/auc:BenchmarkYear')
    expect(benchmark_benchmark_year.length).to eq(1)
    benchmark_benchmark_year.each(&:remove)

    # puts doc
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:BenchmarkYear' is REQUIRED EXACTLY ONCE for 'auc:Benchmark’")
  end

  it "Should issue one ERROR if the auc:LinkedBuildingID is removed" do
    doc = @doc_original.clone
    benchmark_linked_building = doc.root.xpath(@benchmark_scenario + '/../../auc:LinkedPremises/auc:Building/auc:LinkedBuildingID')
    expect(benchmark_linked_building.length).to eq(1)
    benchmark_linked_building.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:LinkedPremises/auc:Building/auc:LinkedBuildingID' is REQUIRED EXACTLY ONCE for 'auc:Benchmark’")
  end
end

# sc.measured.resourceUseReqs
describe 'A PROPER sc.measured.resourceUseReqs' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_measured_resource_use_reqs.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should ensure, for a measured auc:Scenario:
      - an auc:ResourceUses is defined
      - atleast one auc:ResourceUse/auc:EnergyResource is defined" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER sc.measured.resourceUseReqs' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_measured_resource_use_reqs.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000_Prelim_Analysis_01.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @scenarios = 'auc:Facilities/auc:Facility/auc:Reports/auc:Report/auc:Scenarios'
    @resource_uses = @scenarios + '/auc:Scenario/auc:ResourceUses'
    @energy_resource = @resource_uses + '/auc:ResourceUse/auc:EnergyResource'
  end

  it "Should issue two ERRORs for every auc:Scenario/../auc:Measured that does not declare an auc:ResourceUses" do
    doc = @doc_original.clone
    scenarios = doc.root.xpath(@scenarios)

    # Add additional Scenario w/ResourceUses
    Nokogiri::XML::Builder.with(scenarios[0]) do |xml|
      xml['auc'].Scenario('ID' => 'Test-Scenario') {
        xml['auc'].ScenarioType {
          xml['auc'].CurrentBuilding {
            xml['auc'].CalculationMethod {
              xml['auc'].Measured
            }
          }
        }
        xml['auc'].ResourceUses
      }
    end
    # puts doc
    scenario_resource_uses = doc.root.xpath(@resource_uses)
    expect(scenario_resource_uses.length).to eq(2)
    scenario_resource_uses.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Baseline-Measured' MUST HAVE EXACTLY ONE 'auc:ResourceUses' child element")
    expect(errors[1][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Baseline-Measured' MUST HAVE AT LEAST ONE 'auc:ResourceUses/auc:ResourceUse/auc:EnergyResource'")
    expect(errors[2][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Test-Scenario' MUST HAVE EXACTLY ONE 'auc:ResourceUses' child element")
    expect(errors[3][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Test-Scenario' MUST HAVE AT LEAST ONE 'auc:ResourceUses/auc:ResourceUse/auc:EnergyResource'")
  end

  it "Should issue one ERROR for every auc:Scenario/../auc:Measured that does not declare an auc:ResourceUses/auc:ResourceUse/auc:EnergyResource" do
    doc = @doc_original.clone
    scenarios = doc.root.xpath(@scenarios)

    # Add additional Scenario w/ResourceUses/ResourceUse/EnergyResource
    Nokogiri::XML::Builder.with(scenarios[0]) do |xml|
      xml['auc'].Scenario('ID' => 'Test-Scenario') {
        xml['auc'].ScenarioType {
          xml['auc'].CurrentBuilding {
            xml['auc'].CalculationMethod {
              xml['auc'].Measured
            }
          }
        }
        xml['auc'].ResourceUses {
          xml['auc'].ResourceUse {
            xml['auc'].EnergyResource
          }
        }
      }
    end
    # puts doc
    scenario_resource_uses = doc.root.xpath(@resource_uses)
    expect(scenario_resource_uses.length).to eq(2)
    scenario_resource_uses.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Baseline-Measured' MUST HAVE EXACTLY ONE 'auc:ResourceUses' child element")
    expect(errors[1][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Baseline-Measured' MUST HAVE AT LEAST ONE 'auc:ResourceUses/auc:ResourceUse/auc:EnergyResource'")
    expect(errors[2][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Test-Scenario' MUST HAVE EXACTLY ONE 'auc:ResourceUses' child element")
    expect(errors[3][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Test-Scenario' MUST HAVE AT LEAST ONE 'auc:ResourceUses/auc:ResourceUse/auc:EnergyResource'")
  end

  it "Should issue one ERROR for every auc:Scenario/../auc:Measured that does not declare an auc:ResourceUses/auc:ResourceUse/auc:EnergyResource" do
    doc = @doc_original.clone
    scenarios = doc.root.xpath(@scenarios)

    # Add additional Scenario w/ResourceUses/ResourceUse/EnergyResource
    Nokogiri::XML::Builder.with(scenarios[0]) do |xml|
      xml['auc'].Scenario('ID' => 'Test-Scenario') {
        xml['auc'].ScenarioType {
          xml['auc'].CurrentBuilding {
            xml['auc'].CalculationMethod {
              xml['auc'].Measured
            }
          }
        }
        xml['auc'].ResourceUses {
          xml['auc'].ResourceUse {
            xml['auc'].EnergyResource
          }
        }
      }
    end
    # puts doc
    scenario_resource_uses = doc.root.xpath(@resource_uses)
    expect(scenario_resource_uses.length).to eq(2)
    scenario_resource_uses.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Baseline-Measured' MUST HAVE EXACTLY ONE 'auc:ResourceUses' child element")
    expect(errors[1][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Baseline-Measured' MUST HAVE AT LEAST ONE 'auc:ResourceUses/auc:ResourceUse/auc:EnergyResource'")
    expect(errors[2][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Test-Scenario' MUST HAVE EXACTLY ONE 'auc:ResourceUses' child element")
    expect(errors[3][:message]).to eq("[ERROR] 'auc:Scenario' ID = 'Test-Scenario' MUST HAVE AT LEAST ONE 'auc:ResourceUses/auc:ResourceUse/auc:EnergyResource'")
  end
end