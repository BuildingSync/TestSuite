require 'openstudio/extension'
require 'openstudio/model_articulation/os_lib_model_generation_bricr'
require 'buildingsync'
require 'buildingsync/translator'

test_level = ARGV[0]
root_dir = ARGV[1]

inputs_dir = File.join(root_dir, 'tests', test_level, 'inputs')
test_files = Dir.glob(inputs_dir + "/*.xml") # returns array
test_file1 = test_files[0] # Office_Carolina.xml
test_file2 = test_files[1] # L100_Instance1.xml = Chicago, Willis Tower
test_file3 = test_files[2] # L100_Instance2.xml = Office_Carolina, Ithaca NY
to_test = test_file2

# Define output directory.
OUTPUTS_DIR = File.join(root_dir, 'tests', test_level, 'outputs')
SIM_OUTPUT_DIR = File.join(OUTPUTS_DIR, 'Simulation_Files')

# test_files.each do |to_test|

OUT_PATH = File.join(SIM_OUTPUT_DIR, File.basename(to_test, File.extname(to_test)))

# Recursively make directories if do not exist
# tests/test_level/outputs/Simulation_Files/test_file_basename
FileUtils.mkdir_p(OUT_PATH) unless File.exist?(OUT_PATH)
OUT_XML = File.join(SIM_OUTPUT_DIR, File.basename(to_test))
# Define standard to use
standard = "ASHRAE90.1"

# Utilize the weather data defined in the standards library
stds_weath_dir = "/Users/cmosiman/Github/openstudio-standards/data/weather/"
if to_test == test_file1 || to_test == test_file3
  epw_file = stds_weath_dir + "USA_NY_Buffalo.Niagara.Intl.AP.725280_TMY3.epw"
  ddy = stds_weath_dir + "USA_NY_Buffalo.Niagara.Intl.AP.725280_TMY3.ddy"
else
  epw_file = stds_weath_dir + "USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"
  ddy_file = stds_weath_dir + "USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.ddy"
end

translator = BuildingSync::Translator.new(to_test, OUT_PATH)
# translator.add_measure_path() # can add measure path from any local directory
# translator.insert_reporting_measure()
translator.insert_model_measure("SetLightingLoadsByLPD", )
# translator = BuildingSync::Translator.new(to_test, OUT_PATH, epw_file, standard, false)
translator.write_osm
# translator.write_osm(ddy_file)
translator.write_osws
osws = Dir.glob("#{OUT_PATH}/Baseline/in.osw")
runner = OpenStudio::Extension::Runner.new
runner.run_osws(osws, 1)

translator.gather_results(OUT_PATH) # saves results in memory
translator.save_xml(OUT_XML) # writes results out to disk

# what additionally is needed for a measure?

# end

