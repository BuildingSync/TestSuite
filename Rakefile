require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

root = Dir.pwd

desc 'L000 run simulation'
task :L000_run_sim, [:schema_version, :test_file] do |t, args|
  valid_schema_versions = ["schema2.0.0-pr2"]
  valid_test_files = ['root_test_1.xml', 'L000_Instance2.xml', 'L000_Instance2_bad.xml']
  puts args
  if valid_schema_versions.include?(args[:schema_version]) && valid_test_files.include?(args[:test_file])
    ruby "tests/tester.rb Level_000 #{args[:schema_version]} #{args[:test_file]} #{root}"
  else
    puts "usage: bundle exec rake L000_run_sim[schema_version, file_to_run]"
    puts "[schema_version] is one of: 'schema2.0.0-pr2'"
    puts "[file_to_run] is one of: 'root_test_1.xml', 'L000_Instance2.xml'"
  end
end

desc 'L100 run simulation'
task :L100_run_sim, [:schema_version, :test_file] do |t, args|
  valid_schema_versions = ["schema2.0.0-pr2"]
  valid_test_files = ['L100_Instance1.xml', 'L100_Instance2.xml']
  puts args
  if valid_schema_versions.include?(args[:schema_version]) && valid_test_files.include?(args[:test_file])
    ruby "tests/tester.rb Level_100 #{args[:schema_version]} #{args[:test_file]} #{root}"
  else
    puts "usage: bundle exec rake L100_run_sim[schema_version, file_to_run]"
    puts "[schema_version] is one of: 'schema2.0.0-pr2'"
    puts "[file_to_run] is one of: 'L100_Instance1.xml', 'L100_Instance2.xml', 'L100_Instance2_bad.xml'"
  end
end

# desc 'Generate schematron XML for level'
# task :gen_sch do
#   if ARGV[1]bun
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