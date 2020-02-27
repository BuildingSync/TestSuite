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

  it "Should have, under an auc:TypicalOccupantUsages:
      One auc:TypicalOccupantUsageValue
      One auc:TypicalOccupantUsageUnits" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
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

  it "Should have, under an auc:TypicalOccupantUsages:
      One auc:TypicalOccupantUsage/auc:TypicalOccupantUsageUnits of 'Hours per week' " do
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
    @typ_usages = @section_string + "/auc:TypicalOccupantUsages"
    @typ_usage = @section_string + "/auc:TypicalOccupantUsages/auc:TypicalOccupantUsage"
    @typ_usage_val = @typ_usage + "/auc:TypicalOccupantUsageValue"
    @typ_usage_units = @typ_usage + "/auc:TypicalOccupantUsageUnits"
    @units_to_find = "'Hours per week'"
  end

  it "Will fail and issue one ERROR for each auc:TypicalOccupantUsages element that does not have an auc:TypicalOccupantUsage/auc:TypicalOccupantUsageUnits of 'Hours per week'" do
    doc = @doc_original.clone
    typ_usage_units = doc.root.xpath(@typ_usage_units + "[text() = #{@units_to_find}]")

    # Iterate through all auc:TypicalOccupantUsageValue elements
    # Should be 2 from L100_Copy.xml.  Only the first one is removed.
    typ_usage_units[0].remove

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:TypicalOccupantUsage' with child element 'auc:TypicalOccupantUsageUnits' having value #{@units_to_find} is REQUIRED EXACTLY ONCE for 'auc:TypicalOccupantUsages'. Current number of occurrences: 0")
  end

  it "Will fail and issue one ERROR for each auc:TypicalOccupantUsages element that has more than one auc:TypicalOccupantUsage/auc:TypicalOccupantUsageUnits of 'Hours per week'" do
    doc = @doc_original.clone
    typ_usages = doc.root.xpath(@typ_usages)
    typ_usages.each do |usages|
      Nokogiri::XML::Builder.with(usages) do |xml|
        xml['auc'].TypicalOccupantUsage {
          xml['auc'].TypicalOccupantUsageUnits "Hours per week"
          xml['auc'].TypicalOccupantUsageValue "92"
        }
      end
    end

    # Based on doc, which has 4 auc:TypicalOccupantUsage elements (initially),
    # there should now be a total of 6 auc:TypicalOccupantUsage elements, with
    # 4 having auc:TypicalOccupantUsageUnits = 'Hours per week'. Each
    # auc:TypicalOccupantUsages elements will have 2.  This should now mean there will
    # be two errors issued, one for each of the auc:TypicalOccupantUsages elements.

    # Begin schematron validation
    errors = @stron.validate(doc)
    typ_usage = doc.root.xpath(@typ_usage)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(typ_usage.length).to eq(6)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:TypicalOccupantUsage' with child element 'auc:TypicalOccupantUsageUnits' having value #{@units_to_find} is REQUIRED EXACTLY ONCE for 'auc:TypicalOccupantUsages'. Current number of occurrences: 2")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:TypicalOccupantUsage' with child element 'auc:TypicalOccupantUsageUnits' having value #{@units_to_find} is REQUIRED EXACTLY ONCE for 'auc:TypicalOccupantUsages'. Current number of occurrences: 2")
  end
end

describe "A PROPER occ.levels.haveQuantityAndType" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_levels_have_quantity_and_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @section_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section"
    @occ_level = @section_string + "/auc:OccupancyLevels/auc:OccupancyLevel"
  end

  it "Should have, under an auc:OccupancyLevel, one auc:OccupantQuantityType and one auc:OccupantQuantity" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end

  it "Should not fail if an auc:OccupancyLevel/auc:OccupantType element is added" do
    doc = @doc_original.clone
    occ_level = doc.root.xpath(@occ_level)

    # Add an auc:OccupantType to the first element
    Nokogiri::XML::Builder.with(occ_level[0]) do |xml|
      xml['auc'].OccupantType "No specific occupant type"
    end

    occ_level = doc.root.xpath(@occ_level)
    # puts occ_level

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe "An IMPROPER occ.levels.haveQuantityAndType" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_levels_have_quantity_and_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @section_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section"
    @occ_level = @section_string + "/auc:OccupancyLevels/auc:OccupancyLevel"
    @occ_quantity = @occ_level + "/auc:OccupantQuantity"
    @occ_quantity_type = @occ_level + "/auc:OccupantQuantityType"
  end

  it "Will fail and issue one ERROR for each auc:OccupancyLevel element that does not have an auc:OccupantQuantity" do
    doc = @doc_original.clone
    occ_quantity = doc.root.xpath(@occ_quantity)

    # Iterate through all auc:OccupantQuantity elements
    # Should be 2 from L100_Copy.xml.
    count = 0
    occ_quantity.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(count).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:OccupancyQuantityType' and 'auc:OccupantQuantity' are REQUIRED EXACTLY ONCE for: 'auc:OccupancyLevel'")
    expect(errors[1][:message]).to eq("[ERROR] elements 'auc:OccupancyQuantityType' and 'auc:OccupantQuantity' are REQUIRED EXACTLY ONCE for: 'auc:OccupancyLevel'")
  end

  it "Will fail and issue one ERROR for each auc:OccupancyLevel element that does not have an auc:OccupantQuantityType" do
    doc = @doc_original.clone
    occ_quantity_type = doc.root.xpath(@occ_quantity_type)

    # Iterate through all auc:OccupantQuantity elements
    # Should be 2 from L100_Copy.xml
    occ_quantity_type[0].remove

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors[0][:message]).to eq("[ERROR] elements 'auc:OccupancyQuantityType' and 'auc:OccupantQuantity' are REQUIRED EXACTLY ONCE for: 'auc:OccupancyLevel'")
  end
end

describe "A PROPER occ.levels.oneOfType" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_levels_one_of_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @section_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section"
    @occ_level = @section_string + "/auc:OccupancyLevels/auc:OccupancyLevel"
  end

  it "Should have, under an auc:OccupancyLevels, exactly one auc:OccupancyLevel/auc:OccupantQuantityType of 'Peak total occupants'" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end

  it "Should not fail if an auc:OccupancyLevel element with auc:OccupantQuantityType is added with different units than 'Peak total occupants'" do
    doc = @doc_original.clone
    occ_levels = doc.root.xpath(@section_string + "/auc:OccupancyLevels")

    # puts occ_levels

    # Add an auc:OccupantLevel to the first element
    Nokogiri::XML::Builder.with(occ_levels[0]) do |xml|
      xml['auc'].OccupancyLevel {
        xml['auc'].OccupantQuantityType "Adults"
        xml['auc'].OccupantQuantity "12"
      }
    end

    # occ_levels = doc.root.xpath(@section_string + "/auc:OccupancyLevels")
    # puts occ_levels

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe "An IMPROPER occ.levels.oneOfType" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/occ_levels_one_of_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @section_string = "auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section"
    @occ_levels = @section_string + "/auc:OccupancyLevels"
    @occ_level = @section_string + "/auc:OccupancyLevels/auc:OccupancyLevel"
    @occ_quantity_type = @occ_level + "/auc:OccupantQuantityType"
    @units_to_find = "'Peak total occupants'"
  end

  it "Will fail and issue one ERROR for each auc:OccupancyLevels element that does not have an auc:OccupancyLevel/auc:OccupantQuantityType of 'Peak total occupants'" do
    doc = @doc_original.clone
    occ_quantity_type = doc.root.xpath(@occ_quantity_type + "[text() = #{@units_to_find}]")

    occ_quantity_type[0].remove

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:OccupancyLevel' with child element 'auc:OccupantQuantityType' having value #{@units_to_find} is REQUIRED EXACTLY ONCE for 'auc:OccupancyLevels'. Current number of occurrences: 0")
  end

  it "Will fail and issue one ERROR for each auc:OccupancyLevels element that has more than one an auc:OccupancyLevel/auc:OccupantQuantityType of 'Peak total occupants'" do
    doc = @doc_original.clone
    occ_levels = doc.root.xpath(@occ_levels)
    occ_levels.each do |levels|
      Nokogiri::XML::Builder.with(levels) do |xml|
        xml['auc'].OccupancyLevel {
          xml['auc'].OccupantQuantityType "Peak total occupants"
          xml['auc'].OccupantQuantity "12"
        }
      end
    end

    # Based on the doc, which has 2 auc:OccupancyLevel elements (initially)
    # there should now be a total of 4 auc:OccupancyLevel elements, with
    # 4 having auc:OccupantQuantityType = 'Peak total occupants'.  Each
    # auc:OccupancyLevels elements wil have 2.  There should now be 2
    # errors issued.

    # Begin schematron validation
    errors = @stron.validate(doc)
    occ_level = doc.root.xpath(@occ_level)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(occ_level.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:OccupancyLevel' with child element 'auc:OccupantQuantityType' having value #{@units_to_find} is REQUIRED EXACTLY ONCE for 'auc:OccupancyLevels'. Current number of occurrences: 2")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:OccupancyLevel' with child element 'auc:OccupantQuantityType' having value #{@units_to_find} is REQUIRED EXACTLY ONCE for 'auc:OccupancyLevels'. Current number of occurrences: 2")
  end
end