require "spec_helper"
require "schematron-nokogiri"

def add_floor_area_of_type(type, floor_areas_elements, value=1)
  floor_areas_elements.each do |floor_areas_element|
    Nokogiri::XML::Builder.with(floor_areas_element) do |xml|
      xml['auc'].FloorArea {
        xml['auc'].FloorAreaType "#{type}"
        xml['auc'].FloorAreaValue "#{value}"
      }
    end
  end
  return floor_areas_elements
end

describe "A PROPER fa.maxOneOfEachType" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_max_one_of_each_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document

  end

  it "Should have, under an auc:FloorAreas, maximum one of each auc:FloorArea/auc:FloorAreaType" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe "AN IMPROPER fa.maxOneOfEachType" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_max_one_of_each_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building"
    @building_floor_areas_string = @building_string + "/auc:FloorAreas"
  end

  it "Will fail and issue one ERROR for each auc:FloorAreas that has multiple auc:FloorArea/auc:FloorAreaType elemnts with the same enumerated value" do
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

describe "A PROPER fa.haveTypeAndValue" do
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

describe "AN IMPROPER fa.haveTypeAndValue" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/floor_have_type_and_value.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @building_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building"
    @building_floor_areas_string = @building_string + "/auc:FloorAreas"
    @building_floor_areas_floor_area_string = @building_floor_areas_string + "/auc:FloorArea"
    @building_floor_areas_floor_area_floor_area_type_string = @building_floor_areas_floor_area_string + "/auc:FloorAreaType"
    @building_floor_areas_floor_area_floor_area_value_string = @building_floor_areas_floor_area_string + "/auc:FloorAreaValue"
  end

  it "Will fail and issue one ERROR for every auc:FloorArea element that doesn't specify an auc:FloorAreaType" do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_type = doc.root.xpath(@building_floor_areas_floor_area_floor_area_type_string)

    expect(building_floor_areas_floor_area_floor_area_type.length).to eq(4)
    building_floor_areas_floor_area_floor_area_type.each do |el|
      el.remove
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    puts "Schematron errors:"
    puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[2][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[3][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
  end

  it "Will fail and issue one ERROR for every auc:FloorArea element that doesn't specify an auc:FloorAreaType" do
    doc = @doc_original.clone
    building_floor_areas_floor_area_floor_area_value = doc.root.xpath(@building_floor_areas_floor_area_floor_area_value_string)

    expect(building_floor_areas_floor_area_floor_area_value.length).to eq(4)
    building_floor_areas_floor_area_floor_area_value.each do |el|
      el.remove
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    puts "Schematron errors:"
    puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[2][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
    expect(errors[3][:message]).to eq("[ERROR] elements 'auc:FloorAreaType' and 'auc:FloorAreaValue' are REQUIRED EXACTLY ONCE for: 'auc:FloorArea'")
  end
end
