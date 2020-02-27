source 'http://rubygems.org'
ruby '~>2.2'

# gem "nokogiri_schematron_builder"i

gem 'rake', '12.3.1'
gem 'rexml', '3.2.2'

gem 'rspec', '~> 3.8'
gem 'multipart-post', '2.1.1'
gem 'geocoder'
gem 'rubocop', '~> 0.54.0'

allow_local = false

if allow_local && File.exist?('../openstudio-model-articulation-gem')
  gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'DA'
  # gem 'openstudio-model-articulation', path: '../openstudio-model-articulation-gem'
else
  gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'DA'
end


if allow_local && File.exists?('../BuildingSync-gem')
  gem 'buildingsync', path: '../BuildingSync-gem'
else
  gem 'buildingsync', github: 'BuildingSync/BuildingSync-gem', branch: 'DA_Test'
end


# simplecov has an unneccesary dependency on native json gem, use fork that does not require this
gem 'simplecov', github: 'NREL/simplecov'