require 'openstudio/extension'
require 'openstudio/model_articulation/os_lib_model_generation_bricr'
require 'buildingsync'
require 'buildingsync/translator'

# Read in arguments
test_level = ARGV[0]
schema_version = ARGV[1]
test_file = ARGV[2]
root_dir = ARGV[3]

# Define general relevant directories
test_level_dir = File.join(root_dir, 'tests', schema_version, test_level)
inputs_dir = File.join(test_level_dir, 'inputs')
outputs_dir = File.join(test_level_dir, 'outputs')
sim_outputs_dir = File.join(outputs_dir, 'Simulation_Files')

# File specific setup
test_file = File.join(inputs_dir, test_file)
output_path = File.join(sim_outputs_dir, File.basename(test_file, File.extname(test_file)))

# Recursively make directories if do not exist
# tests/test_level/outputs/Simulation_Files/test_file_basename
FileUtils.mkdir_p(output_path) unless File.exist?(output_path)

# Define XML file to write out to
output_xml = File.join(sim_outputs_dir, File.basename(test_file))

# Instantiate translator
translator = BuildingSync::Translator.new(test_file, output_path)

# Write OSM and OSW files
translator.write_osm
translator.write_osws

# Run the OSW
runner_opts = {:num_parallel => 1}
translator.run_osws(runner_opts)

# Gather and save results
translator.gather_results(output_path) # saves results in memory
translator.save_xml(output_xml) # writes results out to disk
