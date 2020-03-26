require 'spec_helper'
require 'json'
require 'rexml/document'
require 'openstudio/extension'
require 'openstudio/model_articulation/os_lib_model_generation_bricr'
require 'buildingsync'
require 'buildingsync/translator'



describe 'Translate' do
  before(:all) do
    @remove_files = true
    if ENV['REMOVE_FILES']
      @remove_files = ENV['REMOVE_FILES'].to_bool
    end
  end
  describe 'A PROPER schema2.0.0 L000_OpenStudio_Simulation_01.xml' do
    before(:all) do
      @f = 'L000_OpenStudio_Simulation_01'
      @test_file = File.join(File.dirname(__FILE__), "../use_cases/schema2.0.0/examples/#{@f}.xml")
      @output_path = File.join(File.dirname(__FILE__), 'schema2.0.0', @f)
      FileUtils.mkdir_p(@output_path) unless File.exist?(@output_path)
      # TODO: make sure it validates against schema 2.0
      @translator = BuildingSync::Translator.new(@test_file, @output_path, nil, 'ASHRAE90.1', false)
      @result_from_write_osm = @translator.write_osm
      @result_from_write_osw = @translator.write_osws # this just returns the Baseline scenario
      @output_osm = File.join(@output_path, 'in.osm')
      @output_osw = File.join(@output_path, 'Baseline', 'in.osw')
    end

    it "Should create an L000_OpenStudio_Simulation_01/in.osm file" do
      expect(File.exist?(@output_osm)).to be true
    end

    it "Should have a system_type of 'VAV with reheat'" do
      expect(@result_from_write_osm["system_type"]).to eq("VAV with reheat")
    end

    it "Should have a bldg_type of 'LargeOffice'" do
      expect(@result_from_write_osm["bldg_type"]).to eq("LargeOffice")
    end

    it "Should have a template of 'DOE Ref Pre-1980'" do
      expect(@result_from_write_osm["template"]).to eq("DOE Ref Pre-1980")
    end

    it "Should create an L000_OpenStudio_Simulation_01/Baseline/in.osw file" do
      expect(File.exist?(@output_osw)).to be true
    end
    after(:all) do
      if @remove_files
        puts "Removing dir: #{@output_path}"
        FileUtils.remove_dir(@output_path)
      end
    end
  end

  describe 'A PROPER schema2.0.0 L000_OpenStudio_Simulation_02.xml' do
    before(:all) do
      @f = 'L000_OpenStudio_Simulation_02'
      @test_file = File.join(File.dirname(__FILE__), "../use_cases/schema2.0.0/examples/#{@f}.xml")
      @output_path = File.join(File.dirname(__FILE__), 'schema2.0.0', @f)
      FileUtils.mkdir_p(@output_path) unless File.exist?(@output_path)
      # TODO: make sure it validates against schema 2.0
      @translator = BuildingSync::Translator.new(@test_file, @output_path, nil, 'ASHRAE90.1', false)
      @result_from_write_osm = @translator.write_osm
      @result_from_write_osw = @translator.write_osws # this just returns the Baseline scenario
      @output_osm = File.join(@output_path, 'in.osm')
      @output_osw = File.join(@output_path, 'Baseline', 'in.osw')
      m = OpenStudio::Model::Model.load(@output_osm)
      m = m.get
      bldg = m.building.get
      puts "Number of people: #{bldg.numberOfPeople}"
    end

    it "Should create an L000_OpenStudio_Simulation_02/in.osm file" do
      expect(File.exist?(@output_osm)).to be true
    end

    it "Should have a system_type of 'PSZ-AC with gas coil heat'" do
      expect(@result_from_write_osm["system_type"]).to eq("PSZ-AC with gas coil heat")
    end

    it "Should have a bldg_type of 'SmallOffice'" do
      expect(@result_from_write_osm["bldg_type"]).to eq("SmallOffice")
    end

    it "Should have a template of 'DOE Ref Pre-1980'" do
      expect(@result_from_write_osm["template"]).to eq("DOE Ref Pre-1980")
    end

    it "Should create an L000_OpenStudio_Simulation_02/Baseline/in.osw file" do
      expect(File.exist?(@output_osw)).to be true
    end
    after(:all) do
      if @remove_files
        puts "Removing dir: #{@output_path}"
        FileUtils.remove_dir(@output_path)
      end
    end
  end

  describe 'A PROPER schema2.0.0 L100_OpenStudio_Simulation_01.xml' do
    before(:all) do
      @f = 'L100_OpenStudio_Simulation_01'
      @test_file = File.join(File.dirname(__FILE__), "../use_cases/schema2.0.0/examples/#{@f}.xml")
      @output_path = File.join(File.dirname(__FILE__), 'schema2.0.0', @f)
      FileUtils.mkdir_p(@output_path) unless File.exist?(@output_path)
      # TODO: make sure it validates against schema 2.0
      @translator = BuildingSync::Translator.new(@test_file, @output_path, nil, 'ASHRAE90.1', false)
      @result_from_write_osm = @translator.write_osm
      @result_from_write_osw = @translator.write_osws # this just returns the Baseline scenario
      @output_osm = File.join(@output_path, 'in.osm')
      @output_osw = File.join(@output_path, 'Baseline', 'in.osw')
      @m = OpenStudio::Model::Model.load(@output_osm)
      @m = @m.get
      @bldg = @m.building.get
    end

    it "Should create an L100_OpenStudio_Simulation_01/in.osm file" do
      expect(File.exist?(@output_osm)).to be true
      puts @result_from_write_osm
    end

    it "Should have a template of '90.1-2013'" do
      expect(@result_from_write_osm["template"]).to eq("90.1-2013")
    end

    it "Should create an L100_OpenStudio_Simulation_01/Baseline/in.osw file" do
      expect(File.exist?(@output_osw)).to be true
    end

    it "Should have a total number of occupants: 371 + 123 = 494" do
      number_of_people = @bldg.numberOfPeople.to_i

      # As defined in XML file: 371 + 123 = 494
      expect(number_of_people).to eq(494)
    end

    it "Should have the same number of stories as specified by: FloorsAboveGrade: 2" do
      # TODO: Can't figure out if this is happening correctly based on the number of floors
      #   specified by the XML file, or just perchance...?
      number_of_stories = @m.getBuildingStorys.size

      expect(number_of_stories).to eq(2)
    end

    it "Should change the number of stories in the OSM when the XML is changed and re-translated.  FloorsAboveGrade: 4" do
      # TODO: Figure out if BSync-gem is reading:
        # FloorsAboveGrade
        # ConditionedFloorsAboveGrade, etc.

      doc = REXML::Document.new(File.new(@test_file))
      floors_above_grade = REXML::XPath.match(doc, "//auc:Building/auc:FloorsAboveGrade")
      cond_floors = REXML::XPath.match(doc, "//auc:Building/auc:ConditionedFloorsAboveGrade")
      puts floors_above_grade
      floors_above_grade[0].text = 4
      cond_floors[0].text = 4
      temp_file = "#{@output_path}/temp.xml"
      File.open(temp_file, 'w') do |file|
        doc.write(file)
      end
      translator = BuildingSync::Translator.new(temp_file, @output_path, nil, 'ASHRAE90.1', false)
      result_from_write_osm = translator.write_osm
      result_from_write_osw = translator.write_osws # this just returns the Baseline scenario

      m = OpenStudio::Model::Model.load(@output_osm)
      m = m.get
      number_of_stories = m.getBuildingStorys.size

      # TODO: Currently, it is getting set to 3 Stories.
      expect(number_of_stories).to eq(4)

      # Remove temp file
      if @remove_files
        File.delete(temp_file)
      end
    end

    it "Should change the number of people in the OSM when the XML is changed and re-translated.  New value should be: 500 + 123 = 623" do
      doc = REXML::Document.new(File.new(@test_file))
      occ_quantity = REXML::XPath.match(doc, "//auc:Section[@ID='Section-Retail']/auc:OccupancyLevels/auc:OccupancyLevel/auc:OccupantQuantity")
      occ_quantity[0].text = 500
      temp_file = "#{@output_path}/temp.xml"
      File.open(temp_file, 'w') do |file|
        doc.write(file)
      end
      translator = BuildingSync::Translator.new(temp_file, @output_path, nil, 'ASHRAE90.1', false)
      result_from_write_osm = translator.write_osm
      result_from_write_osw = translator.write_osws # this just returns the Baseline scenario

      m = OpenStudio::Model::Model.load(@output_osm)
      m = m.get
      bldg = m.building.get
      number_of_people = bldg.numberOfPeople.to_i

      # As defined in XML file: 500 + 123 = 623
      expect(number_of_people).to eq(623)

      # Remove temp file
      File.delete(temp_file)
    end

    # # TODO: How to check that different sections have different systems, i.e. PSZ-AC (retail) or PVAV (office)?
    # it "Should have a system_type of 'PSZ-AC with gas coil heat'" do
    #   expect(@result_from_write_osm["system_type"]).to eq("PSZ-AC with gas coil heat")
    # end
    #
    # # TODO: How to check that different sections have different occupancy types, i.e. Retail, Office?
    # it "Should have a bldg_type of 'RetailStandalone'" do
    #   expect(@result_from_write_osm["bldg_type"]).to eq("RetailStandalone")
    # end
    after(:all) do
      if @remove_files
        puts "Removing dir: #{@output_path}"
        FileUtils.remove_dir(@output_path)
      end
    end
  end
end