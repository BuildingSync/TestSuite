require "spec_helper"
require "schematron-nokogiri"

describe "A PROPER occ.typUsage.haveUnitsAndValue" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_typical_usage_have_units_and_value.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document

  end

  it "Should have, under an auc:TypicalOccupantUsages, one auc:TypicalOccupantUsageValue and one auc:TypicalOccupantUsageUnits" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    puts "Schematron errors:"
    puts errors
    expect(errors.length).to eq(0)
  end
end

describe "An IMPROPER occ.typUsage.haveUnitsAndValue" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_typical_usage_have_units_and_value.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @section_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section"
    @typ_usage = @section_string + "/auc:TypicalOccupantUsages/auc:TypicalOccupantUsage"
    @typ_usage_val = @typ_usage + "/auc:TypicalOccupantUsageValue"
    @typ_usage_units = @typ_usage + "/auc:TypicalOccupantUsageUnits"
  end

  it "Will fail and issue one ERROR for each auc:TypicalOccupantUsage that does not have an auc:TypicalOccupantUsageValue" do
    doc = @doc_original.clone
    typ_usage_vals = doc.root.xpath(@typ_usage_val)

    # Iterate through all auc:TypicalOccupantUsageValue elements and remove
    # Should be 4 from L100_Copy.xml
    count = 0
    typ_usage_vals.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(4)
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
    expect(errors[2][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
    expect(errors[3][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
  end

  it "Will fail and issue one ERROR for each auc:TypicalOccupantUsage that does not have an auc:TypicalOccupantUsageUnits" do
    doc = @doc_original.clone
    typ_usage_units = doc.root.xpath(@typ_usage_units)

    # Iterate through all auc:TypicalOccupantUsageUnits elements and remove
    # Should be 4 from L100_Copy.xml
    count = 0
    typ_usage_units.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(4)
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
    expect(errors[2][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
    expect(errors[3][:message]).to eq("[ERROR] elements 'auc:TypicalOccupantUsageValue' and 'auc:TypicalOccupantUsageUnits' are REQUIRED EXACTLY ONCE for: 'auc:TypicalOccupantUsage'")
  end
end

describe "A PROPER occ.oneOfType.typicalUsageUnits" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_typical_usage_have_units_and_value.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document

  end

  it "Should have, under an auc:TypicalOccupantUsages, one auc:TypicalOccupantUsageValue and one auc:TypicalOccupantUsageUnits" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe "An IMPROPER occ.oneOfType.typicalUsageUnits" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_one_of_type_typical_usage_units.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @section_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section"
    @typ_usage = @section_string + "/auc:TypicalOccupantUsages/auc:TypicalOccupantUsage"
    @typ_usage_val = @typ_usage + "/auc:TypicalOccupantUsageValue"
    @typ_usage_units = @typ_usage + "/auc:TypicalOccupantUsageUnits"
    @units_to_find = "'Hours per week'"
  end

  it "Will fail and issue one ERROR for each auc:TypicalOccupantUsages element that does not have an auc:TypicalOccupantUsage/auc:TypicalOccupantUsageUnits of 'Hours per week'" do
    doc = @doc_original.clone
    typ_usage_units = doc.root.xpath(@typ_usage_units + "[text() = #{@units_to_find}]")

    puts typ_usage_units

    # Iterate through all auc:TypicalOccupantUsageValue elements and remove
    # Should be 4 from L100_Copy.xml
    count = 0
    typ_usage_units.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    puts "Schematron errors:"
    puts errors
    expect(errors.length).to eq(0)
  end

  it "Will fail and issue one ERROR for each auc:TypicalOccupantUsage that does not have an auc:TypicalOccupantUsageUnits" do

  end
end