require 'spec_helper'
require 'schematron-nokogiri'

describe 'A PROPER id check' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/ids_all.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/id.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end
  it "Should have IDs for all elements specified in id.xml" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe "An IMPROPER id check" do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/ids_all.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/id.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
  end
  it "Will fail and issue one error for every auc:Facility that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Facility/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Facility' MUST HAVE an @ID attribute.")
  end
  it "Will fail and issue one error for every auc:Site that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Site/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Site' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:Building that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Building/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Building' MUST HAVE an @ID attribute.  Refer to: 'auc:Site' ID='Site1'")
    expect(errors[1][:message]).to eq("[ERROR] 'auc:Building' MUST HAVE an @ID attribute.  Refer to: 'auc:Site' ID='Site1'")
  end
  it "Will fail and issue one error for every auc:Section that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Section/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Section' MUST HAVE an @ID attribute.  Refer to: 'auc:Building' ID='Building1'")
  end
  it "Will fail and issue one error for every auc:HVACSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:HVACSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:HVACSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:HeatingPlant that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:HeatingPlant/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:HeatingPlant' MUST HAVE an @ID attribute.  Refer to: 'auc:HVACSystem' ID='HVACSystem1'")
  end
  it "Will fail and issue one error for every auc:CoolingPlant that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:CoolingPlant/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:CoolingPlant' MUST HAVE an @ID attribute.  Refer to: 'auc:HVACSystem' ID='HVACSystem1'")
  end
  it "Will fail and issue one error for every auc:CondenserPlant that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:CondenserPlant/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:CondenserPlant' MUST HAVE an @ID attribute.  Refer to: 'auc:HVACSystem' ID='HVACSystem1'")
  end
  it "Will fail and issue one error for every auc:HeatingSource that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:HeatingSource/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:HeatingSource' MUST HAVE an @ID attribute.  Refer to: 'auc:HVACSystem' ID='HVACSystem1'")
  end
  it "Will fail and issue one error for every auc:CoolingSource that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:CoolingSource/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:CoolingSource' MUST HAVE an @ID attribute.  Refer to: 'auc:HVACSystem' ID='HVACSystem1'")
  end
  it "Will fail and issue one error for every auc:Delivery that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Delivery/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Delivery' MUST HAVE an @ID attribute.  Refer to: 'auc:HVACSystem' ID='HVACSystem1'")
  end
  it "Will fail and issue one error for every auc:OtherHVACSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:OtherHVACSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:OtherHVACSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:HVACSystem' ID='HVACSystem1'")
  end
  it "Will fail and issue one error for every auc:LightingSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:LightingSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:LightingSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:DomesticHotWaterSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:DomesticHotWaterSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:DomesticHotWaterSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:PumpSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:PumpSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:PumpSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:FanSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:FanSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:FanSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:MotorSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:MotorSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:MotorSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:WallSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:WallSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:WallSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:RoofSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:RoofSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:RoofSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:FenestrationSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:FenestrationSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:FenestrationSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:ExteriorFloorSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:ExteriorFloorSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:ExteriorFloorSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:FoundationSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:FoundationSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:FoundationSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:CriticalITSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:CriticalITSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:CriticalITSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:PlugLoad that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:PlugLoad/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:PlugLoad' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:ProcessLoad that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:ProcessLoad/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:ProcessLoad' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:ConveyanceSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:ConveyanceSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:ConveyanceSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:OnsiteStorageTransmissionGenerationSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:OnsiteStorageTransmissionGenerationSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:OnsiteStorageTransmissionGenerationSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:AirInfiltrationSystem that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:AirInfiltrationSystem/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:AirInfiltrationSystem' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:Schedule that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Schedule/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Schedule' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:Measure that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Measure/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Measure' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:Report that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Report/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Report' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:Scenario that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Scenario/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Scenario' MUST HAVE an @ID attribute.  Refer to: 'auc:Report' ID='Report1'")
  end
  it "Will fail and issue one error for every auc:ResourceUse that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:ResourceUse/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:ResourceUse' MUST HAVE an @ID attribute.  Refer to: 'auc:Scenario' ID='Scenario1'")
  end
  it "Will fail and issue one error for every auc:Qualification that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Qualification/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Qualification' MUST HAVE an @ID attribute.  Refer to: 'auc:Report' ID='Report1'")
  end
  it "Will fail and issue one error for every auc:Utility that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Utility/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Utility' MUST HAVE an @ID attribute.  Refer to: 'auc:Report' ID='Report1'")
  end
  it "Will fail and issue one error for every auc:Contact that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Contact/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Contact' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
  it "Will fail and issue one error for every auc:Tenant that does not have an @ID" do
    doc = @doc_original.clone

    all_ids = doc.xpath("//auc:Tenant/@ID")
    # puts all_ids

    all_ids.each(&:remove)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] 'auc:Tenant' MUST HAVE an @ID attribute.  Refer to: 'auc:Facility' ID='Facility1'")
  end
end
