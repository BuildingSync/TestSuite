require 'spec_helper'
require 'schematron-nokogiri'

describe 'A PROPER be.L000BuildingInfo' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/building_L000_building_info.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an auc:Building:
      One auc:PremisesName
      One auc:BuildingClassification
      One auc:OccupancyClassification
      One auc:YearOfConstruction" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'An IMPROPER be.L000BuildingInfo' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/building_L000_building_info.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
  end

  it 'Will fail and issue one ERROR when no auc:PremisesName element is specified' do
    doc = @doc_original.clone
    building_premises_name = doc.root.xpath(@building_string + '/auc:PremisesName')

    count = 0
    building_premises_name.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:PremisesName' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:BuildingClassification element is specified' do
    doc = @doc_original.clone
    building_building_classification = doc.root.xpath(@building_string + '/auc:BuildingClassification')

    count = 0
    building_building_classification.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:BuildingClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:OccupancyClassification element is specified' do
    doc = @doc_original.clone
    building_occupancy_classification = doc.root.xpath(@building_string + '/auc:OccupancyClassification')

    count = 0
    building_occupancy_classification.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:YearOfConstruction element is specified' do
    doc = @doc_original.clone
    building_year_of_construction = doc.root.xpath(@building_string + '/auc:YearOfConstruction')

    count = 0
    building_year_of_construction.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:YearOfConstruction' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end
end

describe 'A PROPER be.mainDetails.L100.audit' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/building_main_details_L100_audit.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
  end

  it "Should have, under an auc:Building:
      One auc:PremisesName
      One auc:BuildingClassification
      One auc:OccupancyClassification
      One auc:YearOfConstruction
      One auc:BuildingAutomationSystem
      One auc:HistoricalLandmark
      One auc:PercentOccupiedByOwner
      One auc:PercentLeasedByOwner
      One auc:ConditionedFloorsAboveGrade
      One auc:ConditionedFloorsBelowGrade
      One auc:FloorsAboveGrade or one auc:UnconditionedFloorsAboveGrade
      One auc:FloorsBelowGrade or one auc:UnconditionedFloorsBelowGrade

      Is recommended to have:
      One auc:YearOfLastEnergyAudit
      One auc:RetrocommissioningDate
      One auc:YearOfLastMajorRemodel" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end

  it 'Should not fail if auc:FloorsAboveGrade is replaced by auc:UnconditionedFloorsAboveGrade' do
    doc = @doc_original.clone
    building_conditioned_floors_below_grade = doc.root.xpath(@building_string + '/auc:ConditionedFloorsBelowGrade')
    building_floors_above_grade = doc.root.xpath(@building_string + '/auc:FloorsAboveGrade')

    count = 0
    building_floors_above_grade.each do |el|
      el.remove
      count += 1
    end
    expect(count).to eq(1)

    # If validated now, there should be one ERROR
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)

    building_unconditioned_floors_above_grade = Nokogiri::XML::Element.new('auc:UnconditionedFloorsAboveGrade', doc)
    building_unconditioned_floors_above_grade.content = '0'

    # This
    building_conditioned_floors_below_grade.after(building_unconditioned_floors_above_grade)
    # puts doc.to_xml
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end

  it 'Should not fail if auc:FloorsBelowGrade is replaced by auc:UnconditionedFloorsBelowGrade' do
    doc = @doc_original.clone
    building_conditioned_floors_below_grade = doc.root.xpath(@building_string + '/auc:ConditionedFloorsBelowGrade')
    building_floors_below_grade = doc.root.xpath(@building_string + '/auc:FloorsBelowGrade')

    count = 0
    building_floors_below_grade.each do |el|
      el.remove
      count += 1
    end
    expect(count).to eq(1)

    # If validated now, there should be one ERROR
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)

    building_unconditioned_floors_below_grade = Nokogiri::XML::Element.new('auc:UnconditionedFloorsBelowGrade', doc)
    building_unconditioned_floors_below_grade.content = '0'

    building_conditioned_floors_below_grade.after(building_unconditioned_floors_below_grade)
    # puts doc.to_xml
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER be.mainDetails.L100.audit' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/building_main_details_L100_audit.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
  end

  it 'Will fail and issue one ERROR when no auc:PremisesName element is specified' do
    doc = @doc_original.clone
    building_premises_name = doc.root.xpath(@building_string + '/auc:PremisesName')

    count = 0
    building_premises_name.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:PremisesName' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:BuildingClassification element is specified' do
    doc = @doc_original.clone
    building_building_classification = doc.root.xpath(@building_string + '/auc:BuildingClassification')

    count = 0
    building_building_classification.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:BuildingClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:OccupancyClassification element is specified' do
    doc = @doc_original.clone
    building_occupancy_classification = doc.root.xpath(@building_string + '/auc:OccupancyClassification')

    count = 0
    building_occupancy_classification.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:YearOfConstruction element is specified' do
    doc = @doc_original.clone
    building_year_of_construction = doc.root.xpath(@building_string + '/auc:YearOfConstruction')

    count = 0
    building_year_of_construction.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:YearOfConstruction' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:BuildingAutomationSystem element is specified' do
    doc = @doc_original.clone
    building_building_automation_system = doc.root.xpath(@building_string + '/auc:BuildingAutomationSystem')

    count = 0
    building_building_automation_system.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:BuildingAutomationSystem' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:HistoricalLandmark element is specified' do
    doc = @doc_original.clone
    building_historical_landmark = doc.root.xpath(@building_string + '/auc:HistoricalLandmark')

    count = 0
    building_historical_landmark.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:HistoricalLandmark' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:PercentOccupiedByOwner element is specified' do
    doc = @doc_original.clone
    building_percent_occupied_by_owner = doc.root.xpath(@building_string + '/auc:PercentOccupiedByOwner')

    count = 0
    building_percent_occupied_by_owner.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:PercentOccupiedByOwner' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:PercentLeasedByOwner element is specified' do
    doc = @doc_original.clone
    building_percent_leased_by_owner = doc.root.xpath(@building_string + '/auc:PercentLeasedByOwner')

    count = 0
    building_percent_leased_by_owner.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:PercentLeasedByOwner' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:ConditionedFloorsAboveGrade element is specified' do
    doc = @doc_original.clone
    building_conditioned_floors_above_grade = doc.root.xpath(@building_string + '/auc:ConditionedFloorsAboveGrade')

    count = 0
    building_conditioned_floors_above_grade.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:ConditionedFloorsAboveGrade' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:ConditionedFloorsBelowGrade element is specified' do
    doc = @doc_original.clone
    building_conditioned_floors_below_grade = doc.root.xpath(@building_string + '/auc:ConditionedFloorsBelowGrade')

    count = 0
    building_conditioned_floors_below_grade.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:ConditionedFloorsBelowGrade' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when neither auc:FloorsAboveGrade nor auc:UnconditionedFloorsAboveGrade element is specified' do
    doc = @doc_original.clone
    building_floors_above_grade = doc.root.xpath(@building_string + '/auc:FloorsAboveGrade')

    count = 0
    building_floors_above_grade.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:FloorsAboveGrade' or 'auc:UnconditionedFloorsAboveGrade' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when neither auc:FloorsBelowGrade nor auc:UnconditionedFloorsBelowGrade element is specified' do
    doc = @doc_original.clone
    building_floors_below_grade = doc.root.xpath(@building_string + '/auc:FloorsBelowGrade')

    count = 0
    building_floors_below_grade.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:FloorsBelowGrade' or 'auc:UnconditionedFloorsBelowGrade' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one WARNING when no auc:YearOfLastEnergyAudit element is specified' do
    doc = @doc_original.clone
    building_year_of_last_energy_audit = doc.root.xpath(@building_string + '/auc:YearOfLastEnergyAudit')

    count = 0
    building_year_of_last_energy_audit.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[WARNING] element 'auc:YearOfLastEnergyAudit' is RECOMMENDED for: 'auc:Building'")
  end

  it 'Will fail and issue one WARNING when no auc:RetrocommissioningDate element is specified' do
    doc = @doc_original.clone
    building_retrocommissioning_date = doc.root.xpath(@building_string + '/auc:RetrocommissioningDate')

    count = 0
    building_retrocommissioning_date.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[WARNING] element 'auc:RetrocommissioningDate' is RECOMMENDED for: 'auc:Building'")
  end

  it 'Will fail and issue one WARNING when no auc:YearOfLastMajorRemodel element is specified' do
    doc = @doc_original.clone
    building_year_of_last_major_remodel = doc.root.xpath(@building_string + '/auc:YearOfLastMajorRemodel')

    count = 0
    building_year_of_last_major_remodel.each do |el|
      el.remove
      count += 1
    end
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[WARNING] element 'auc:YearOfLastMajorRemodel' is RECOMMENDED for: 'auc:Building'")
  end
end

describe 'A PROPER be.simpleLocationDetails' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/building_simple_location_details.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an auc:Building/auc:Address:
      One auc:City
      One auc:State
      One auc:PostalCode
      One auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER be.simpleLocationDetails' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/building_simple_location_details.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @address_string = @building_string + '/auc:Address'
  end

  it 'Will fail and issue one ERROR when no auc:City element is specified' do
    doc = @doc_original.clone
    building_address_city = doc.root.xpath(@address_string + '/auc:City')

    count = 0
    building_address_city.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(1)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:City' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:State element is specified' do
    doc = @doc_original.clone
    building_address_state = doc.root.xpath(@address_string + '/auc:State')

    count = 0
    building_address_state.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(1)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:State' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:PostalCode element is specified' do
    doc = @doc_original.clone
    building_address_postal_code = doc.root.xpath(@address_string + '/auc:PostalCode')

    count = 0
    building_address_postal_code.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(1)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:PostalCode' within element 'auc:Address' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end

  it 'Will fail and issue one ERROR when no auc:StreetAddress element is specified' do
    doc = @doc_original.clone
    building_address_street_address_detail_simplified_street_address = doc.root.xpath(@address_string + '/auc:StreetAddressDetail/auc:Simplified/auc:StreetAddress')

    count = 0
    building_address_street_address_detail_simplified_street_address.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(1)
    # puts doc.to_xml
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:StreetAddress' within element 'auc:Address/auc:StreetAddressDetail/auc:Simplified' is REQUIRED EXACTLY ONCE for: 'auc:Building'")
  end
end
