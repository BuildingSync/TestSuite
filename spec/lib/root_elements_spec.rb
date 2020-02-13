require "spec_helper"
require "schematron-nokogiri"

describe "A PROPER oneOfEachUntilBuilding" do
  before(:all) do
    xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @xml_file = Nokogiri::XML File.open xml_path

    sch_path = File.join(File.dirname(__FILE__), '../files/root_one_of_each_until_building.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file
  end

  it "Should have one auc:Facility, one auc:Site, one auc:Building" do
    errors = @stron.validate(@xml_file)
    expect(errors.length).to eq(0)
  end
end

describe "An IMPROPER oneOfEachUntilBuilding" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_one_of_each_until_building.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file
    @ns = "auc"
    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @site_string = @facility_string + "/auc:Sites/auc:Site"
    @building_string = @site_string + "/auc:Buildings/auc:Building"
  end

  it "Will fail and issue two warnings when two auc:Facility elements are specified" do
    doc = @doc_original.clone
    facilities = doc.root.xpath(@facility_string) # returns a Nokogiri::XML::NodeSet
    new_facility = Nokogiri::XML::Node.new("auc:Facility", doc) # An empty Element is generally equivalent to a Node
    facilities.before(new_facility) # insert new facility element before the first Facility element

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)

    # Wants exactly one auc:Facility element
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Facility' is REQUIRED EXACTLY ONCE for: 'auc:Facilities'")

    # New auc:Facility element now expected to have a auc:Sites element
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:Sites' is REQUIRED EXACTLY ONCE for: 'auc:Facility'")
  end

  it "Will fail and issue two warnings when two auc:Site elements are specified" do
    doc = @doc_original.clone
    sites = doc.root.xpath(@site_string)
    new_site = Nokogiri::XML::Element.new("auc:Site", doc)
    sites.after(new_site)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)

    # Wants exactly one auc:Site element
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Site' is REQUIRED EXACTLY ONCE for: 'auc:Sites'")

    # New auc:Site element now expected to have a auc:Buildings element
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:Buildings' is REQUIRED EXACTLY ONCE for: 'auc:Site'")
  end

  it "Will fail and issue one warning when two auc:Building elements are specified" do
    doc = @doc_original.clone
    buildings = doc.root.xpath(@building_string)
    new_building = Nokogiri::XML::Element.new("auc:Building", doc)
    buildings.after(new_building)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)

    # Wants exactly one auc:Building element
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Building' is REQUIRED EXACTLY ONCE for: 'auc:Buildings'")
  end
end

describe "A PROPER oneOfEachFacilityUntilScenario" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_one_of_each_facility_until_scenario.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @report_string = @facility_string + "/auc:Reports/auc:Report"
    @scenario_string = @report_string + "/auc:Scenarios/auc:Scenario"

    # Build up correct Report node
    @good_report_node = Nokogiri::XML::Element.new("auc:Report", @doc_original)
    @scenarios = Nokogiri::XML::Element.new("auc:Scenarios", @doc_original)
    @scenario = Nokogiri::XML::Element.new("auc:Scenario", @doc_original)
    @scenarios.add_child(@scenario)
    @good_report_node.add_child(@scenarios)
  end

  it "Should have, under an auc:Facility element, one of each element until a auc:Scenario" do
    doc = @doc_original.clone
    errors = @stron.validate(doc)
    expect(errors.length).to eq(0)
  end

  it "Should not fail when multiple properly defined auc:Report elements provided" do
    doc = @doc_original.clone
    original = doc.root.xpath(@report_string)
    original.after(@good_report_node)

    # Begin schematron validation
    errors = @stron.validate(doc)
    expect(errors.length).to eq(0)
  end

  it "Should not fail when multiple auc:Scenario elements provided" do
    doc = @doc_original.clone
    original = doc.root.xpath(@scenario_string)

    # Add two Scenario elements
    original.after(@scenario.clone)
    original.after(@scenario.clone)

    # Begin schematron validation
    errors = @stron.validate(doc)
    expect(errors.length).to eq(0)
  end
end

describe "An IMPROPER oneOfEachFacilityUntilScenario" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_one_of_each_facility_until_scenario.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @report_string = @facility_string + "/auc:Reports/auc:Report"
    @scenario_string = @report_string + "/auc:Scenarios/auc:Scenario"
  end

  it "Will fail and issue one warning when no auc:Report element is specified" do
    doc = @doc_original.clone
    all_report_elements = doc.root.xpath(@report_string)

    # Iterate through all auc:Report elements and remove
    # Should be just one from root.xml
    count = 0
    all_report_elements.each do |el|
      el.remove
      count += 1
    end

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(count)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Report' is REQUIRED AT LEAST ONCE for: 'auc:Reports'")
  end

  it "Will fail and issue one warning when no auc:Scenario element is specified" do
    doc = @doc_original.clone
    all_scenario_elements = doc.root.xpath(@scenario_string)

    # Iterate through all auc:Scenario elements and remove
    # Should be just one from root.xml
    count = 0
    all_scenario_elements.each do |el|
      el.remove
      count += 1
    end

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(count)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Scenario' is REQUIRED AT LEAST ONCE for: 'auc:Scenarios'")
  end
end

describe "A PROPER oneOfEachFacilityUntilContacts" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_one_of_each_facility_until_contacts.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
  end

  it "Should have, under an auc:Facility element, exactly one auc:Contacts element" do
    doc = @doc_original.clone
    errors = @stron.validate(doc)
    puts "Schematron errors:"
    puts errors
    expect(errors.length).to eq(0)
  end

end

describe "An IMPROPER oneOfEachFacilityUntilContacts" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_one_of_each_facility_until_contacts.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @contacts_string = @facility_string + "/auc:Contacts"
  end

  it "Will fail if no auc:Contacts element is specified" do
    doc = @doc_original.clone
    all_contacts_elements = doc.root.xpath(@contacts_string)

    # Iterate through all auc:Contacts elements and remove
    # Should be just one from root.xml
    count = 0
    all_contacts_elements.each do |el|
      el.remove
      count += 1
    end

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(count)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Contacts' is REQUIRED EXACTLY ONCE for: 'auc:Facility'")
  end

  it "Will fail if more than one auc:Contacts element is specified" do
    doc = @doc_original.clone
    contacts = doc.root.xpath(@contacts_string)
    contacts_element = Nokogiri::XML::Element.new("auc:Contacts", doc)
    contacts.before(contacts_element)

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Contacts' is REQUIRED EXACTLY ONCE for: 'auc:Facility'")
  end
end

describe "A PROPER atleastOneReportInFacility" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_atleast_one_report_in_facility.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @report_string = @facility_string + "/auc:Reports/auc:Report"
  end

  it "Should have, under an auc:Facility element, at least one auc:Report element" do
    doc = @doc_original.clone
    all_report_elements = doc.root.xpath(@report_string)

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(all_report_elements.length).to eq(1)
    expect(errors.length).to eq(0)
  end

  it "Should not fail if more than one auc:Report element is specified" do
    doc = @doc_original.clone
    all_report_elements = doc.root.xpath(@report_string)
    report_element = Nokogiri::XML::Element.new("auc:Report", doc)
    all_report_elements.after(report_element)
    all_report_elements = doc.root.xpath(@report_string)

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(all_report_elements.length).to eq(2)
    expect(errors.length).to eq(0)
  end

end

describe "An IMPROPER atleastOneReportInFacility" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_atleast_one_report_in_facility.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @report_string = @facility_string + "/auc:Reports/auc:Report"
  end

  it "Will fail if no auc:Report element is specified" do
    doc = @doc_original.clone
    all_report_elements = doc.root.xpath(@report_string)

    # Iterate through all auc:Report elements and remove
    # Should be just one from root.xml
    count = 0
    all_report_elements.each do |el|
      el.remove
      count += 1
    end

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(count)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Report' is REQUIRED AT LEAST ONCE for: 'auc:Facility'")
  end
end

describe "A PROPER atleastOneScenarioInReport" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_atleast_one_scenario_in_report.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @report_string = @facility_string + "/auc:Reports/auc:Report"
    @scenario_string = @report_string + "/auc:Scenarios/auc:Scenario"
  end

  it "Should have, under an auc:Report element, at least one auc:Scenario element" do
    doc = @doc_original.clone
    all_scenario_elements = doc.root.xpath(@scenario_string)

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(all_scenario_elements.length).to eq(1)
    expect(errors.length).to eq(0)
  end

  it "Should not fail if more than one auc:Scenario element is specified" do
    doc = @doc_original.clone
    all_scenario_elements = doc.root.xpath(@scenario_string)
    scenario_element = Nokogiri::XML::Element.new("auc:Scenario", doc)
    all_scenario_elements.after(scenario_element)
    all_scenario_elements = doc.root.xpath(@scenario_string)

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(all_scenario_elements.length).to eq(2)
    expect(errors.length).to eq(0)
  end

end

describe "An IMPROPER atleastOneScenarioInReport" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/root_atleast_one_scenario_in_report.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/root.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = "auc:Facilities/auc:Facility"
    @report_string = @facility_string + "/auc:Reports/auc:Report"
    @scenario_string = @report_string + "/auc:Scenarios/auc:Scenario"
  end

  it "Will fail if no auc:Scenario element is specified" do
    doc = @doc_original.clone
    all_scenario_elements = doc.root.xpath(@scenario_string)

    # Iterate through all auc:Scenario elements and remove
    # Should be just one from root.xml
    count = 0
    all_scenario_elements.each do |el|
      el.remove
      count += 1
    end

    # Begin Schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(1)
    expect(errors.length).to eq(count)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Scenario' is REQUIRED AT LEAST ONCE for: 'auc:Report'")
  end
end