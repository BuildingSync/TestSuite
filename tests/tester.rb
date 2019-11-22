require 'openstudio/extension'
require 'openstudio/model_articulation/os_lib_model_generation_bricr'
require 'buildingsync'
require 'buildingsync/translator'

test_level = ARGV[0]
root_dir = ARGV[1]

inputs_dir = File.join(root_dir, 'tests', test_level, 'inputs')
test_files = Dir.glob(inputs_dir + "/*.xml") # returns array
test_file1 = test_files[0]

# Define output directory.
OUTPUTS_DIR = File.join(root_dir, 'tests', test_level, 'outputs')
SIM_OUTPUT_DIR = File.join(OUTPUTS_DIR, 'Simulation_Files')
OUT_PATH = File.join(SIM_OUTPUT_DIR, File.basename(test_file1))

# Recursively make directories if do not exist
# tests/test_level/outputs/Simulation_Files/test_file_basename
FileUtils.mkdir_p(OUT_PATH) unless File.exist?(OUT_PATH)
OUT_XML = File.join(SIM_OUTPUT_DIR, test_file1)

# Define standard to use
standard = "ASHRAE90.1"

# Utilize the weather data defined in the standards library
stds_weath_dir = "/Users/cmosiman/Github/openstudio-standards/data/weather/"
epw_file = stds_weath_dir + "USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"
ddy_file = stds_weath_dir + "USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.ddy"

translator = BuildingSync::Translator.new(test_file1, OUT_PATH, epw_file, standard, false)
translator.write_osm(ddy_file)
translator.write_osws

osws = Dir.glob("#{OUT_PATH}/Baseline/in.osw")
puts osws

