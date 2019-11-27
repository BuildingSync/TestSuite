require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

root = Dir.pwd

desc 'L100 test'
task :L100_test do
  puts root
  ruby "tests/tester.rb Level_100 #{root}"
end

desc 'Generate schematron XML for level'
task :gen_sch do
  if ARGV[1]
    level = ARGV[1]
    puts level
    puts level == "L100"
    if level == "L100"
      ruby "tests/Level_100/Test_L100.rb"
    else
      puts "invalid level.  specify one of: L100"
    end
  else
    puts "usage: bundle exec rake gen_sch [level]"
    puts "[level] is one of: L100"
    puts "used to generate a schematron document for the given level"
  end
end