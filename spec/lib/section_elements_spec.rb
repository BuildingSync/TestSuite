require "spec_helper"
require "schematron-nokogiri"

describe "A PROPER sec.mainDetails" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/section_main_details.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../../tests/schema2.0.0-pr2/Level_100/inputs/L100_Instance1_bad.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document

  end

  it "Should have one auc:OccupancyClassification and is recommended to have one auc:OriginalOccupancyClassification" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    puts "Schematron errors:"
    # puts errors
    # expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:OccupancyClassification' is REQUIRED EXACTLY ONCE for: 'auc:Section'")
    expect(errors[1][:message]).to eq("[WARNING] element 'auc:OriginalOccupancyClassification' is RECOMMENDED for: 'auc:Section'")
  end
end