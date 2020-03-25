require 'spec_helper'
require 'schematron-nokogiri'

describe 'A PROPER sc.benchmarkType' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/scenario_benchmark_type.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L000.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end

  it "Should have, under an auc:Section[auc:SectionType='Space function'], one auc:OccupancyClassification and is recommended to have one auc:OriginalOccupancyClassification" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)

    expect(errors.length).to eq(0)
  end
end