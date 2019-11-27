source 'http://rubygems.org'
ruby '~>2.2'

# gem "nokogiri_schematron_builder"

gem 'rake', '12.3.1'
gem 'rexml', '3.2.2'

gem 'rspec', '~> 3.8'
gem 'multipart-post', '2.1.1'
gem 'geocoder'

allow_local = false

if allow_local && File.exist?('../OpenStudio-extension-gem')
  # gem 'openstudio-extension', github: 'NREL/OpenStudio-extension-gem', branch: 'develop'
  gem 'openstudio-extension', path: '../OpenStudio-extension-gem'
else
  gem 'openstudio-extension', github: 'NREL/OpenStudio-extension-gem', branch: 'develop'
end

if allow_local && File.exist?('../openstudio-model-articulation-gem')
  # gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'develop'
  gem 'openstudio-model-articulation', path: '../openstudio-model-articulation-gem'
else
  gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'DA'
end

if allow_local && File.exist?('../openstudio-common-measures-gem')
  # gem 'openstudio-model-articulation', github: 'NREL/openstudio-common-measures-gem', branch: 'develop'
  gem 'openstudio-common-measures', path: '../openstudio-common-measures-gem'
else
  gem 'openstudio-common-measures', github: 'NREL/openstudio-common-measures-gem', branch: 'develop'
end

if allow_local && File.exist?('../openstudio-standards-gem')
  gem 'openstudio-standards', '>=0.2.9'
  # gem 'openstudio-standards', path: '../openstudio-standards'
else
  gem 'openstudio-standards', '>=0.2.9'
end

if allow_local && File.exists?('../BuildingSync-gem')
  # gem 'buildingsync', github: 'BuildingSync/BuildingSync-gem', branch: 'DA'
  gem 'buildingsync', path: '../BuildingSync-gem'
else
  gem 'buildingsync', github: 'BuildingSync/BuildingSync-gem', branch: 'DA_Test'
end


# simplecov has an unneccesary dependency on native json gem, use fork that does not require this
gem 'simplecov', github: 'NREL/simplecov'