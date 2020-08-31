require 'spec_helper'
require 'schematron-nokogiri'

describe 'L000 OpenStudio Simulation Checks - Schematron' do
  describe 'A PROPER spec/use_cases/schema2.0.0/L000_OpenStudio_Simulation.sch' do
    before(:all) do
      sch_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/L000_OpenStudio_Simulation.sch')
      sch_file = Nokogiri::XML File.open sch_path
      @stron = SchematronNokogiri::Schema.new sch_file

    end

    it "Should issue three 'errors' at the [INFO] level when run against spec/use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_01.xml" do
      xml_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_01.xml')
      doc = Nokogiri::XML File.open xml_path # create a Nokogiri::XML::Document

      # Begin schematron validation
      errors = @stron.validate(doc)
      errors_error = []
      errors_warning = []
      errors_info = []
      errors.each do |err|
        errors_error << err[:message] if err[:message].include? "[ERROR]"
        errors_warning << err[:message] if err[:message].include? "[WARNING]"
        errors_info  << err[:message] if err[:message].include? "[INFO]"
      end
      # puts "Schematron errors:"
      # puts errors
      expect(errors_error.length).to eq(0)
      expect(errors_warning.length).to eq(0)
      expect(errors_info.length).to eq(3)
      expect(errors_info[0]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 1, 'auc:Building' = 0")
      expect(errors_info[1]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 1, 'auc:Building' = 0")
      expect(errors_info[2]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0")
    end

    it "Should issue three 'errors' at the [INFO] level when run against spec/use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_02.xml" do
      xml_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/examples/L000_OpenStudio_Simulation_02.xml')
      doc = Nokogiri::XML File.open xml_path # create a Nokogiri::XML::Document

      # Begin schematron validation
      errors = @stron.validate(doc)
      errors_error = []
      errors_warning = []
      errors_info = []
      errors.each do |err|
        errors_error << err[:message] if err[:message].include? "[ERROR]"
        errors_warning << err[:message] if err[:message].include? "[WARNING]"
        errors_info  << err[:message] if err[:message].include? "[INFO]"
      end
      # puts "Schematron errors:"
      # puts errors
      expect(errors_error.length).to eq(0)
      expect(errors_warning.length).to eq(0)
      expect(errors_info.length).to eq(3)
      expect(errors_info[0]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0")
      expect(errors_info[1]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0")
      expect(errors_info[2]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 1, 'auc:Building' = 0")
    end
  end
end

describe 'L100 OpenStudio Simulation Checks - Schematron' do
  describe 'A PROPER spec/use_cases/schema2.0.0/L100_OpenStudio_Simulation.sch' do
    before(:all) do
      sch_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/L100_OpenStudio_Simulation.sch')
      sch_file = Nokogiri::XML File.open sch_path
      @stron = SchematronNokogiri::Schema.new sch_file
    end

    it "Should not issue any [ERROR] or [WARNING] level when run against spec/use_cases/schema2.0.0/examples/L100_OpenStudio_Simulation_01.xml" do
      xml_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/examples/L100_OpenStudio_Simulation_01.xml')
      doc = Nokogiri::XML File.open xml_path # create a Nokogiri::XML::Document

      # Begin schematron validation
      errors = @stron.validate(doc)
      errors_error = []
      errors_warning = []
      errors_info = []
      errors.each do |err|
        errors_error << err[:message] if err[:message].include? "[ERROR]"
        errors_warning << err[:message] if err[:message].include? "[WARNING]"
        errors_info  << err[:message] if err[:message].include? "[INFO]"
      end
      # puts "Schematron errors:"
      # puts errors
      expect(errors_error.length).to eq(0)
      expect(errors_warning.length).to eq(0)
      expect(errors_info[0]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
      expect(errors_info[1]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
      expect(errors_info[2]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0")
    end
  end
end

describe 'SEED Checks - Schematron' do
  describe 'A PROPER spec/use_cases/schema2.0.0/SEED.sch' do
    before(:all) do
      sch_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/SEED.sch')
      sch_file = Nokogiri::XML File.open sch_path
      @stron = SchematronNokogiri::Schema.new sch_file
    end

    it "Should not issue any [ERROR] or [WARNING] level when run against spec/use_cases/schema2.0.0/examples/SEED_01.xml" do
      xml_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/examples/SEED_01.xml')
      doc = Nokogiri::XML File.open xml_path # create a Nokogiri::XML::Document

      # Begin schematron validation
      errors = @stron.validate(doc)
      errors_error = []
      errors_warning = []
      errors_info = []
      errors.each do |err|
        errors_error << err[:message] if err[:message].include? "[ERROR]"
        errors_warning << err[:message] if err[:message].include? "[WARNING]"
        errors_info  << err[:message] if err[:message].include? "[INFO]"
      end
      expect(errors_error.length).to eq(0)
      expect(errors_warning.length).to eq(0)
    end
  end
end

describe 'BRICR Checks - Schematron' do
  describe 'A PROPER spec/use_cases/schema2.0.0/BRICR_SEED.sch' do
    before(:all) do
      sch_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/BRICR_SEED.sch')
      sch_file = Nokogiri::XML File.open sch_path
      @stron = SchematronNokogiri::Schema.new sch_file
    end

    it "Should not issue any [ERROR] or [WARNING] level when run against spec/use_cases/schema2.0.0/examples/SEED_01.xml" do
      xml_path = File.join(File.dirname(__FILE__), '../../use_cases/schema2.0.0/examples/SEED_01.xml')
      doc = Nokogiri::XML File.open xml_path # create a Nokogiri::XML::Document

      # Begin schematron validation
      errors = @stron.validate(doc)
      errors_error = []
      errors_warning = []
      errors_info = []
      errors.each do |err|
        errors_error << err[:message] if err[:message].include? "[ERROR]"
        errors_warning << err[:message] if err[:message].include? "[WARNING]"
        errors_info  << err[:message] if err[:message].include? "[INFO]"
      end
      expect(errors_error.length).to eq(0)
      expect(errors_warning.length).to eq(0)
    end
  end
end
