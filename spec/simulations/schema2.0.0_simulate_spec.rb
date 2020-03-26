require 'spec_helper'
require 'json'
require 'openstudio/extension'
require 'openstudio/model_articulation/os_lib_model_generation_bricr'
require 'buildingsync'
require 'buildingsync/translator'

describe 'Simulate' do
  before(:all) do
    @remove_files = true
    if ENV['REMOVE_FILES']
      @remove_files = ENV['REMOVE_FILES'].to_bool
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
      @finished_job = File.join(@output_path, 'Baseline', 'finished.job')
      @failed_job = File.join(@output_path, 'Baseline', 'failed.job')
    end

    it "Should successfully simulate a Baseline building" do
      # Run the OSW
      runner_opts = { num_parallel: 1 }
      @translator.run_osws(runner_opts)
      expect(File.exist?(@finished_job)).to be true
      expect(File.exist?(@failed_job)).to be false
    end

    it "Should output OpenStudio Results via L000_OpenStudio_Simulation_02/Baseline/reports/openstudio_results_report.html" do
      os_reports = File.join(@output_path, 'Baseline/reports/openstudio_results_report.html')
      expect(File.exist?(os_reports)).to be true
    end

    it "Should have a total building floor area of 31,053ft2 +- 1ft2 (floating point)" do
      f = File.read(File.join(@output_path, 'Baseline/results.json'))
      results = JSON.parse(f)
      area = results["OpenStudioResults"]["total_building_area"]
      expect(area).to be_within(1).of(31053)
    end
    after(:all) do
      if @remove_files
        puts "Removing dir: #{@output_path}"
        FileUtils.remove_dir(@output_path)
      end
    end
  end
end

