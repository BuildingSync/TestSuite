require 'spec_helper'
require 'json'
require 'openstudio/extension'
require 'openstudio/model_articulation/os_lib_model_generation_bricr'
require 'buildingsync'
require 'buildingsync/translator'

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

end

