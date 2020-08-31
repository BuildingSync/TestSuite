require 'spec_helper'
require 'schematron-nokogiri'

describe 'A PROPER sec.mainDetails' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/section_main_details_L100_audit.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an auc:Section[auc:SectionType='Space function'], one auc:OccupancyClassification and is recommended to have one auc:OriginalOccupancyClassification" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)

    expect(errors.length).to eq(0)
  end
end

describe 'An IMPROPER sec.mainDetails' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/section_main_details_L100_audit.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @section_string = 'auc:Facilities/auc:Facility/auc:Sites/auc:Site/auc:Buildings/auc:Building/auc:Sections/auc:Section'
    @occ_class_string = @section_string + '/auc:OccupancyClassification'
    @orig_occ_class_string = @section_string + '/auc:OriginalOccupancyClassification'
  end

  it 'Will fail and issue one ERROR for each auc:Section that does not have auc:OccupancyClassification' do
    doc = @doc_original.clone
    all_occ_class = doc.root.xpath(@occ_class_string)

    # Iterate through all auc:OccupancyClassification elements and remove
    # Should be 2 from L100_Copy.xml
    count = 0
    all_occ_class.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(2)
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Section'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Section'")
  end

  it 'Will fail and issue one WARNING for each auc:Section that does not have an auc:OriginalOccupancyClassification' do
    doc = @doc_original.clone
    orig_occ_class = doc.root.xpath(@orig_occ_class_string)

    # Iterate through all auc:OriginalOccupancyClassification elements and remove
    # Should be 2 from L100_Copy.xml
    count = 0
    orig_occ_class.each do |el|
      el.remove
      count += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count).to eq(2)
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[WARNING] element 'auc:OriginalOccupancyClassification' is RECOMMENDED for: 'auc:Section'")
    expect(errors[1][:message]).to eq("[WARNING] element 'auc:OriginalOccupancyClassification' is RECOMMENDED for: 'auc:Section'")
  end

  err = ['Will fail and issue one WARNING for each auc:Section that',
         'does not have an auc:OriginalOccupancyClassification and one ERROR',
         'for each auc:Section that does not have an auc:OccupancyClassification'].join(' ')
  it err do
    doc = @doc_original.clone
    all_occ_class = doc.root.xpath(@occ_class_string)
    orig_occ_class = doc.root.xpath(@orig_occ_class_string)

    # Iterate through all auc:OccupancyClassification elements and remove
    # Should be 2 from L100_Copy.xml
    count_occ = 0
    all_occ_class.each do |el|
      el.remove
      count_occ += 1
    end

    count_orig_occ = 0
    orig_occ_class.each do |el|
      el.remove
      count_orig_occ += 1
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(count_occ).to eq(2)
    expect(count_orig_occ).to eq(2)
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Section'")
    expect(errors[1][:message]).to eq("[WARNING] element 'auc:OriginalOccupancyClassification' is RECOMMENDED for: 'auc:Section'")
    expect(errors[2][:message]).to eq("[ERROR] element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Section'")
    expect(errors[3][:message]).to eq("[WARNING] element 'auc:OriginalOccupancyClassification' is RECOMMENDED for: 'auc:Section'")
  end
end

describe 'A PROPER sec.primarySystems.L100' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/section_primary_systems_L100.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an auc:Section[auc:SectionType='Space function'], one auc:OccupancyClassification and is recommended to have one auc:OriginalOccupancyClassification" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    puts "Schematron errors:"
    puts errors
    expect(errors.length).to eq(0)
  end
end
