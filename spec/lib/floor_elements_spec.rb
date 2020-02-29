require 'spec_helper'
require 'schematron-nokogiri'

def add_floor_area_of_type(type, floor_areas_elements, value = 1)
  floor_areas_elements.each do |floor_areas_element|
    Nokogiri::XML::Builder.with(floor_areas_element) do |xml|
      xml['auc'].FloorArea do
        xml['auc'].FloorAreaType type.to_s
        xml['auc'].FloorAreaValue value.to_s
      end
    end
  end
  return floor_areas_elements
end

describe 'A PROPER fa.maxOneOfEachType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_max_one_of_each_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it 'Should have, under an auc:FloorAreas, maximum one of each auc:FloorArea/auc:FloorAreaType' do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER fa.maxOneOfEachType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_max_one_of_each_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
  end

  it 'Will fail and issue one ERROR for each auc:FloorAreas that has multiple auc:FloorArea/auc:FloorAreaType elemnts with the same enumerated value' do
    doc = @doc_original.clone
    building_floor_areas = doc.root.xpath(@building_floor_areas_string)

    # L100 already has a 'Gross' and 'Heated and Cooled'
    add_floor_area_of_type('Gross', building_floor_areas)
    add_floor_area_of_type('Heated and Cooled', building_floor_areas)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Gross' is ALLOWED NO MORE THAN ONCE for 'auc:FloorAreas'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Heated and Cooled' is ALLOWED NO MORE THAN ONCE for 'auc:FloorAreas'")
  end
end

describe 'A PROPER fa.haveTypeAndValue' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_have_type_and_value.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an:FloorArea:
      One auc:FloorAreaType
      One auc:FloorAreaValue" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER fa.haveTypeAndValue' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_have_type_and_value.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
    @building_floor_areas_floor_area_string = @building_floor_areas_string + '/auc:FloorArea'
    @building_floor_areas_floor_area_floor_area_type_string = @building_floor_areas_floor_area_string + '/auc:FloorAreaType'
    @building_floor_areas_floor_area_floor_area_value_string = @building_floor_areas_floor_area_string + '/auc:FloorAreaValue'
  end

  it "Will fail and issue one ERROR for every auc:FloorArea element that doesn't specify an auc:FloorAreaType" do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_type = doc.root.xpath(@building_floor_areas_floor_area_floor_area_type_string)

    expect(building_floor_areas_floor_area_floor_area_type.length).to eq(4)
    building_floor_areas_floor_area_floor_area_type.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts 'Schematron errors:'
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[2][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[3][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
  end

  it "Will fail and issue one ERROR for every auc:FloorArea element that doesn't specify an auc:FloorAreaValue" do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_value = doc.root.xpath(@building_floor_areas_floor_area_floor_area_value_string)

    expect(building_floor_areas_floor_area_floor_area_value.length).to eq(4)
    building_floor_areas_floor_area_floor_area_value.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts 'Schematron errors:'
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[2][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[3][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
  end

  it "Will fail and issue one ERROR for every auc:FloorArea element that doesn't specify both an auc:FloorAreaType and an auc:FloorAreaValue" do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_value = doc.root.xpath(@building_floor_areas_floor_area_floor_area_value_string)
    building_floor_areas_floor_area_floor_area_type = doc.root.xpath(@building_floor_areas_floor_area_floor_area_type_string)

    expect(building_floor_areas_floor_area_floor_area_value.length).to eq(4)
    expect(building_floor_areas_floor_area_floor_area_type.length).to eq(4)
    building_floor_areas_floor_area_floor_area_value.each(&:remove)
    building_floor_areas_floor_area_floor_area_type.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts 'Schematron errors:'
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[2][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[3][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
  end
end

describe 'A PROPER fa.oneOfType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_one_of_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an:FloorAreas:
      One auc:FloorArea/auc:FloorAreaType with value specified by the function parameter ($floorAreaType).
      For the purposes of this test, this includes: 'Gross', 'Cooled only', 'Heated and Cooled', 'Heated only'" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER fa.oneOfType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_one_of_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
    @building_floor_areas_floor_area_string = @building_floor_areas_string + '/auc:FloorArea'
    @building_floor_areas_floor_area_floor_area_type_string = @building_floor_areas_floor_area_string + '/auc:FloorAreaType'
  end

  it "Will fail and issue one ERROR for each auc:FloorAreas element that does not have an auc:FloorArea/auc:FloorAreaType = $floorAreaType." do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_type_gross = doc.root.xpath(@building_floor_areas_floor_area_floor_area_type_string  + "[text() = 'Gross']")
    building_floor_areas_floor_area_floor_area_type_cooled_only = doc.root.xpath(@building_floor_areas_floor_area_floor_area_type_string  + "[text() = 'Cooled only']")
    building_floor_areas_floor_area_floor_area_type_heated_and_cooled = doc.root.xpath(@building_floor_areas_floor_area_floor_area_type_string  + "[text() = 'Heated and Cooled']")
    building_floor_areas_floor_area_floor_area_type_heated_only = doc.root.xpath(@building_floor_areas_floor_area_floor_area_type_string  + "[text() = 'Heated only']")

    expect(building_floor_areas_floor_area_floor_area_type_gross.length).to eq(1)
    expect(building_floor_areas_floor_area_floor_area_type_cooled_only.length).to eq(1)
    expect(building_floor_areas_floor_area_floor_area_type_heated_and_cooled.length).to eq(1)
    expect(building_floor_areas_floor_area_floor_area_type_heated_only.length).to eq(1)

    building_floor_areas_floor_area_floor_area_type_gross.each(&:remove)
    building_floor_areas_floor_area_floor_area_type_cooled_only.each(&:remove)
    building_floor_areas_floor_area_floor_area_type_heated_and_cooled.each(&:remove)
    building_floor_areas_floor_area_floor_area_type_heated_only.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Gross' is REQUIRED EXACTLY ONCE within element 'auc:FloorArea' for 'auc:FloorAreas'.  Currently occurs: 0")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Cooled only' is REQUIRED EXACTLY ONCE within element 'auc:FloorArea' for 'auc:FloorAreas'.  Currently occurs: 0")
    expect(errors[2][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Heated and Cooled' is REQUIRED EXACTLY ONCE within element 'auc:FloorArea' for 'auc:FloorAreas'.  Currently occurs: 0")
    expect(errors[3][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Heated only' is REQUIRED EXACTLY ONCE within element 'auc:FloorArea' for 'auc:FloorAreas'.  Currently occurs: 0")
  end
end

describe 'A PROPER fa.dontUse' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_dont_use.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an:FloorAreas:
      No auc:FloorAreaType elements = 'Heated' or 'Cooled'" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER fa.dontUse' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_dont_use.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @section_string = @building_string + "/auc:Sections/auc:Section"
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
    @section_floor_areas_string = @section_string + '/auc:FloorAreas'
  end

  it "Will fail and issue one ERROR for each auc:FloorArea element that defines an auc:FloorAreaType = 'Heated' or 'Cooled'" do
    doc = @doc_original.clone
    building_floor_areas = doc.root.xpath(@building_floor_areas_string)
    section_floor_areas = doc.root.xpath(@section_floor_areas_string)

    add_floor_area_of_type('Heated', building_floor_areas)
    add_floor_area_of_type('Cooled', building_floor_areas)

    # L100 has two sections with floor_areas.  this will add to both
    add_floor_area_of_type('Cooled', section_floor_areas)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Heated' within element 'auc:FloorArea' SHOULD NOT BE USED for: 'auc:FloorAreas'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Cooled' within element 'auc:FloorArea' SHOULD NOT BE USED for: 'auc:FloorAreas'")
    expect(errors[2][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Cooled' within element 'auc:FloorArea' SHOULD NOT BE USED for: 'auc:FloorAreas'")
    expect(errors[3][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Cooled' within element 'auc:FloorArea' SHOULD NOT BE USED for: 'auc:FloorAreas'")
  end
end

describe 'A PROPER fa.noneDefinedWarn' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_none_defined_warn.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should provide a WARNING for each auc:FloorArea element that defines an auc:FloorAreaType = $floorAreaType" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(3)
    expect(errors[0][:message]).to eq("[WARNING] element 'auc:FloorAreaType' with value 'Ventilated' is RECOMMENDED for: 'auc:FloorAreas'")
    expect(errors[1][:message]).to eq("[WARNING] element 'auc:FloorAreaType' with value 'Ventilated' is RECOMMENDED for: 'auc:FloorAreas'")
    expect(errors[2][:message]).to eq("[WARNING] element 'auc:FloorAreaType' with value 'Ventilated' is RECOMMENDED for: 'auc:FloorAreas'")
  end
end

describe 'A PROPER fa.oneOfMechType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_one_of_mech_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an auc:FloorAreas, at least one of the following auc:FloorAreaType:
      'Conditioned'
      'Heated and Cooled'
      'Heated only'
      'Cooled only'
      'Ventilated'" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER fa.oneOfMechType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_one_of_mech_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @section_string = @building_string + "/auc:Sections/auc:Section"
    @building_floor_areas_floor_area_string = @building_string + '/auc:FloorAreas/auc:FloorArea'

  end

  it "Will fail and issue one ERROR for every auc:FloorAreas that does not define at least one of auc:FloorAreaType:
      'Conditioned'
      'Heated and Cooled'
      'Heated only'
      'Cooled only'
      'Ventilated'" do
    doc = @doc_original.clone
    building_floor_areas_floor_area = doc.root.xpath(@building_floor_areas_floor_area_string)

    count = 0
    building_floor_areas_floor_area.each do |el|
      if not el.at_xpath("auc:FloorAreaType[text()='Gross']")
        el.remove
        count += 1
      end
    end

    expect(count).to eq(3)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:FloorAreaType' with value 'Conditioned' or 'Heated and Cooled' or 'Heated only' or 'Cooled only' or 'Ventilated' is REQUIRED AT LEAST ONCE for 'auc:FloorAreas'")
  end
end

describe 'A PROPER fa.mechTypeChecks' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_mech_type_checks.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
    @building_floor_areas_floor_area_string = @building_floor_areas_string + '/auc:FloorArea'
  end

  it "Should check, for each auc:FloorAreas element passed, that the following logical conditions are true:
      Gross >= Cooled only + Heated only + Heated and Cooled + Ventilated
      Gross >= Conditioned + Unconditioned" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(7)
    expect(errors[0][:message]).to eq("[INFO] 'Gross' Floor Area: 49390")
    expect(errors[1][:message]).to eq("[INFO] 'Cooled only' Floor Area: 0")
    expect(errors[2][:message]).to eq("[INFO] 'Heated only' Floor Area: 129")
    expect(errors[3][:message]).to eq("[INFO] 'Heated and Cooled' Floor Area: 49261")
    expect(errors[4][:message]).to eq("[INFO] 'Ventilated' Floor Area: 0")
    expect(errors[5][:message]).to eq("[INFO] 'Conditioned' Floor Area: 49390")
    expect(errors[6][:message]).to eq("[INFO] 'Unconditioned' Floor Area: 0")
  end

  it "Should use the 'Conditioned' floor area if specified" do
    doc = @doc_original.clone

    # Change the Gross floor area to be larger
    building_floor_areas_floor_area_floor_area_value_gross = doc.root.xpath(@building_floor_areas_floor_area_string  + "[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue")
    expect(building_floor_areas_floor_area_floor_area_value_gross.length).to eq(1)
    building_floor_areas_floor_area_floor_area_value_gross[0].content = "50000"
    building_floor_areas = doc.root.xpath(@building_floor_areas_string)

    add_floor_area_of_type('Conditioned', building_floor_areas, 49392)
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(7)
    expect(errors[0][:message]).to eq("[INFO] 'Gross' Floor Area: 50000")
    expect(errors[1][:message]).to eq("[INFO] 'Cooled only' Floor Area: 0")
    expect(errors[2][:message]).to eq("[INFO] 'Heated only' Floor Area: 129")
    expect(errors[3][:message]).to eq("[INFO] 'Heated and Cooled' Floor Area: 49261")
    expect(errors[4][:message]).to eq("[INFO] 'Ventilated' Floor Area: 0")
    expect(errors[5][:message]).to eq("[INFO] 'Conditioned' Floor Area: 49392")
    expect(errors[6][:message]).to eq("[INFO] 'Unconditioned' Floor Area: 608")
  end
end

describe 'AN IMPROPER fa.mechTypeChecks' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_mech_type_checks.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
    @building_floor_areas_floor_area_string = @building_floor_areas_string + '/auc:FloorArea'
  end

  it "Will fail and issue one ERROR for each auc:FloorAreas element where the following logical condition is not true:
      Gross >= Conditioned + Unconditioned AND Unconditioned > 0" do
    doc = @doc_original.clone
    building_floor_areas = doc.root.xpath(@building_floor_areas_string)

    # Reduce the Gross floor area value
    building_floor_areas_floor_area_floor_area_value_gross = doc.root.xpath(@building_floor_areas_floor_area_string  + "[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue")
    expect(building_floor_areas_floor_area_floor_area_value_gross.length).to eq(1)
    building_floor_areas_floor_area_floor_area_value_gross[0].content = "123"

    # Add in a Conditioned floor area value so it is not commputed
    add_floor_area_of_type('Conditioned', building_floor_areas, 49392)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(8)
    expect(errors[0][:message]).to eq("[ERROR] Gross Floor Area (123) must be greater than or equal to: Conditioned (49392) + Unconditioned (-49269) AND Unconditioned Floor Area must be > 0")
    expect(errors[1][:message]).to eq("[INFO] 'Gross' Floor Area: 123")
    expect(errors[2][:message]).to eq("[INFO] 'Cooled only' Floor Area: 0")
    expect(errors[3][:message]).to eq("[INFO] 'Heated only' Floor Area: 129")
    expect(errors[4][:message]).to eq("[INFO] 'Heated and Cooled' Floor Area: 49261")
    expect(errors[5][:message]).to eq("[INFO] 'Ventilated' Floor Area: 0")
    expect(errors[6][:message]).to eq("[INFO] 'Conditioned' Floor Area: 49392")
    expect(errors[7][:message]).to eq("[INFO] 'Unconditioned' Floor Area: -49269")
  end

  it "Will fail and issue one ERROR for each auc:FloorAreas element where the following logical condition is not true:
      Conditioned >= Heated and Cooled + Heated only + Cooled only + Ventilated" do
    doc = @doc_original.clone
    building_floor_areas = doc.root.xpath(@building_floor_areas_string)

    # Add in a Conditioned floor area value so it is not commputed, and which is less than others combined: 129 + 49261
    add_floor_area_of_type('Conditioned', building_floor_areas, 500)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(8)
    expect(errors[0][:message]).to eq("[ERROR] Conditioned Floor Area (500) must be greater than or equal to: Heated and Cooled (49261) + Heated only (129) + Cooled only (0) + Ventilated (0)")
    expect(errors[1][:message]).to eq("[INFO] 'Gross' Floor Area: 49390")
    expect(errors[2][:message]).to eq("[INFO] 'Cooled only' Floor Area: 0")
    expect(errors[3][:message]).to eq("[INFO] 'Heated only' Floor Area: 129")
    expect(errors[4][:message]).to eq("[INFO] 'Heated and Cooled' Floor Area: 49261")
    expect(errors[5][:message]).to eq("[INFO] 'Ventilated' Floor Area: 0")
    expect(errors[6][:message]).to eq("[INFO] 'Conditioned' Floor Area: 500")
    expect(errors[7][:message]).to eq("[INFO] 'Unconditioned' Floor Area: 48890")
  end
end

describe 'A PROPER fa.buildingSectionGrossAreaChecks' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_building_section_gross_area_checks.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should not fail if the auc:Building 'Gross' floor area is >= the sum of all 'Gross' auc:FloorArea elements from sections designated as auc:SectionType='Space function'" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[INFO] Building Gross Floor Area: 49390")
    expect(errors[1][:message]).to eq("[INFO] Sum of all auc:Section[auc:SectionType='Space function'] Gross Floor Area: 49390")
  end
end

describe 'AN IMPROPER fa.buildingSectionGrossAreaChecks' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_building_section_gross_area_checks.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @section_string = @building_string + "/auc:Sections/auc:Section"
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
    @building_floor_areas_floor_area_string = @building_floor_areas_string + '/auc:FloorArea'
    @building_floor_areas_floor_area_floor_area_type_string = @building_floor_areas_floor_area_string + '/auc:FloorAreaType'
  end

  it "Will fail and issue one ERROR if the auc:Building 'Gross' floor area is NOT >= the sum of all 'Gross' auc:FloorArea elements from sections designated as auc:SectionType='Space function'" do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_value_gross = doc.root.xpath(@building_floor_areas_floor_area_string  + "[auc:FloorAreaType/text() = 'Gross']/auc:FloorAreaValue")
    building_floor_areas_floor_area_floor_area_value_gross[0].content = 49389

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(3)
    expect(errors[0][:message]).to eq("[ERROR] auc:Building Gross Floor (49389) Area MUST BE GREATER THAN OR EQUAL TO the sum of all Gross Floor areas from elements auc:Section[auc:SectionType='Space function'] (49390)")
    expect(errors[1][:message]).to eq("[INFO] Building Gross Floor Area: 49389")
    expect(errors[2][:message]).to eq("[INFO] Sum of all auc:Section[auc:SectionType='Space function'] Gross Floor Area: 49390")
  end
end

describe 'A PROPER fa.type.valueOrPercent' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_type_value_or_percent.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an auc:FloorArea element, either an auc:FloorAreaValue or auc:FloorAreaPercentage element" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER fa.type.valueOrPercent' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_type_value_or_percent.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building'
    @building_floor_areas_string = @building_string + '/auc:FloorAreas'
    @building_floor_areas_floor_area_string = @building_floor_areas_string + '/auc:FloorArea'
  end

  it "Will fail and issue one ERROR for each auc:FloorArea element that specifies both an auc:FloorAreaValue and auc:FloorAreaPercentage element" do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_value = doc.root.xpath(@building_floor_areas_floor_area_string + "/auc:FloorAreaValue")
    floor_area_percentage = Nokogiri::XML::Element.new('auc:FloorAreaPercentage', doc)
    floor_area_percentage.content = "50"

    count = 0
    building_floor_areas_floor_area_floor_area_value.each do |el|
      el.after(floor_area_percentage.clone)
      count += 1
    end

    expect(count).to eq(4)
    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] either element 'auc:FloorAreaValue' OR 'auc:FloorAreaPercentage' MUST BE SPECIFIED for: 'auc:FloorArea'")
    expect(errors[1][:message]).to eq("[ERROR] either element 'auc:FloorAreaValue' OR 'auc:FloorAreaPercentage' MUST BE SPECIFIED for: 'auc:FloorArea'")
    expect(errors[2][:message]).to eq("[ERROR] either element 'auc:FloorAreaValue' OR 'auc:FloorAreaPercentage' MUST BE SPECIFIED for: 'auc:FloorArea'")
    expect(errors[3][:message]).to eq("[ERROR] either element 'auc:FloorAreaValue' OR 'auc:FloorAreaPercentage' MUST BE SPECIFIED for: 'auc:FloorArea'")
  end
end