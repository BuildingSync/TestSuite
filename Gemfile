source 'http://rubygems.org'
ruby '~>2.2'

gem "schematron-nokogiri"
# gem "nokogiri_schematron_builder"

gem 'rake', '13.0.1'

gem 'geocoder'
gem 'multipart-post', '2.1.1'
gem 'rspec', '~> 3.8'
gem 'rubocop', '~> 0.54.0'

allow_local = false

if allow_local && File.exist?('../openstudio-model-articulation-gem')
  gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: '0.2.X-LTS'
  # gem 'openstudio-model-articulation', path: '../openstudio-model-articulation-gem'
else
  gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: '0.2.X-LTS'
end

if allow_local && File.exist?('../BuildingSync-gem')
  gem 'buildingsync', path: '../BuildingSync-gem'
else
  gem 'buildingsync', github: 'BuildingSync/BuildingSync-gem', branch: 'DA_Update'
end

# simplecov has an unneccesary dependency on native json gem, use fork that does not require this
# gem 'simplecov', github: 'NREL/simplecov'
