require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

root = Dir.pwd

desc 'L000 run simulation'
task :L000_run_sim do
  valid_schema_versions = ["schema2.0.0-pr2"]
  valid_test_files = ['L000_Instance1.xml', 'L000_Instance2.xml']
  if ARGV.size == 3
    if valid_schema_versions.include?(ARGV[1]) && valid_test_files.include?(ARGV[2])
      schema_version = ARGV[1]
      test_file = ARGV[2]
      ruby "tests/tester.rb Level_000 #{schema_version} #{test_file} #{root}"
    end
  else
    puts "usage: bundle exec rake L000_run_sim [schema_version] [file_to_run]"
    puts "[schema_version] is one of: 'schema2.0.0-pr2'"
    puts "[file_to_run] is one of: 'L000_Instance1.xml', 'L000_Instance2.xml'"
  end
end

# desc 'Generate schematron XML for level'
# task :gen_sch do
#   if ARGV[1]
#     level = ARGV[1]
#     puts level
#     puts level == "L100"
#     if level == "L100"
#       ruby "tests/Level_100/Test_L100.rb"
#     else
#       puts "invalid level.  specify one of: L100"
#     end
#   else
#     puts "usage: bundle exec rake gen_sch [level]"
#     puts "[level] is one of: L100"
#     puts "used to generate a schematron document for the given level"
#   end
# end