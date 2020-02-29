require 'spec_helper'
require 'schematron-nokogiri'

describe 'A PROPER sbe.cityStateOrClimateZone' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/site_building_city_state_or_climate_zone.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = 'auc:Facilities/auc:Facility'
    @site_string = @facility_string + '/auc:Sites/auc:Site'
  end

  it "Should have:
      One auc:City and one auc:State or one auc:ClimateZoneType//auc:ClimateZone
      defined at either the auc:Site or auc:Building level" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(3)
    expect(errors[0][:message]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[1][:message]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[2][:message]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0")
  end

  it "Should have not fail if an auc:ClimateZoneType//auc:ClimateZone is also defined" do
    doc = @doc_original.clone
    sites_site = doc.root.xpath(@site_string)
    Nokogiri::XML::Builder.with(sites_site[0]) do |xml|
      xml['auc'].ClimateZoneType {
        xml['auc'].ASHRAE {
          xml['auc'].ClimateZone "5A"
        }
      }
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(3)
    expect(errors[0][:message]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[1][:message]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[2][:message]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 1, 'auc:Building' = 0")
  end
end

describe 'AN IMPROPER sbe.cityStateOrClimateZone' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/site_building_city_state_or_climate_zone.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @facility_string = 'auc:Facilities/auc:Facility'
    @site_string = @facility_string + '/auc:Sites/auc:Site'
  end

  it "Will fail and issue one WARNING if an auc:State is defined at both the auc:Site and auc:Building level" do
    doc = @doc_original.clone
    sites_site = doc.root.xpath(@site_string)
    Nokogiri::XML::Builder.with(sites_site[0]) do |xml|
      xml['auc'].Address {
        xml['auc'].State "CO"
      }
    end

    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[WARNING] elements 'auc:City' and 'auc:State' or element 'auc:ClimateZoneType//auc:ClimateZone' are RECOMMENDED EXACTLY ONCE at either the 'auc:Site' or 'auc:Building' level.")
    expect(errors[1][:message]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[2][:message]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 1, 'auc:Building' = 1")
    expect(errors[3][:message]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0")
  end

  it "Will fail and issue one WARNING if an auc:City is defined at both the auc:Site and auc:Building level" do
    doc = @doc_original.clone
    sites_site = doc.root.xpath(@site_string)
    Nokogiri::XML::Builder.with(sites_site[0]) do |xml|
      xml['auc'].Address {
        xml['auc'].City "Denver"
      }
    end

    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[WARNING] elements 'auc:City' and 'auc:State' or element 'auc:ClimateZoneType//auc:ClimateZone' are RECOMMENDED EXACTLY ONCE at either the 'auc:Site' or 'auc:Building' level.")
    expect(errors[1][:message]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 1, 'auc:Building' = 1")
    expect(errors[2][:message]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[3][:message]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 0, 'auc:Building' = 0")
  end

  it "Will fail and issue one WARNING if an auc:ClimateZoneType//auc:ClimateZone is defined at both the auc:Site and auc:Building level" do
    doc = @doc_original.clone
    sites_site = doc.root.xpath(@site_string)
    buildings_building = doc.root.xpath(@site_string + "/auc:Buildings/auc:Building")

    Nokogiri::XML::Builder.with(sites_site[0]) do |xml|
      xml['auc'].ClimateZoneType {
        xml['auc'].ASHRAE {
          xml['auc'].ClimateZone "5A"
        }
      }
    end

    Nokogiri::XML::Builder.with(buildings_building[0]) do |xml|
      xml['auc'].ClimateZoneType {
        xml['auc'].ASHRAE {
          xml['auc'].ClimateZone "5A"
        }
      }
    end

    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(4)
    expect(errors[0][:message]).to eq("[WARNING] elements 'auc:City' and 'auc:State' or element 'auc:ClimateZoneType//auc:ClimateZone' are RECOMMENDED EXACTLY ONCE at either the 'auc:Site' or 'auc:Building' level.")
    expect(errors[1][:message]).to eq("[INFO] Number of 'auc:City' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[2][:message]).to eq("[INFO] Number of 'auc:State' elements defined at the 'auc:Site' = 0, 'auc:Building' = 1")
    expect(errors[3][:message]).to eq("[INFO] Number of 'auc:ClimateZoneType//auc:ClimateZone' elements defined at the 'auc:Site' = 1, 'auc:Building' = 1")
  end
end