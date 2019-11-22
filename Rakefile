require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

root = Dir.pwd

desc 'L100 test'
task :L100_test do
  ruby "tests/tester.rb Level_100 #{root}"
end

desc 'Generate schematron XML for level'
task :gen_sch do
  if ARGV[0]

  else
    puts "usage: bundle exec rake "
  end
end