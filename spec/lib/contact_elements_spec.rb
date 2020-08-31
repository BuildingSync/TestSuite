require 'spec_helper'
require 'schematron-nokogiri'

describe 'A PROPER con.nameEmailPhone' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/contact_name_email_phone.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @contacts_string = 'auc:Facilities/auc:Facility/auc:Contacts'
    @contact_string = @contacts_string + '/auc:Contact'
    @contact_email_addresses = @contact_string + '/auc:ContactEmailAddresses'
    @contact_email_addresses_contact_email_address = @contact_email_addresses + '/auc:ContactEmailAddress'
    @contact_telephone_numbers = @contact_string + '/auc:ContactTelephoneNumbers'
    @contact_telephone_numbers_contact_telephone_number = @contact_telephone_numbers + '/auc:ContactTelephoneNumber'
  end

  it "Should have:
      One auc:ContactName
      Atleast one auc:ContactEmailAddresses/auc:ContactEmailAddress/auc:EmailAddress
      Atleast one auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber/auc:TelephoneNumber" do

    doc = @doc_original.clone
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end

  it 'Should not fail when multiple auc:ContactEmailAddress/auc:EmailAddress elements are provided' do
    doc = @doc_original.clone
    contact_contact_email_addresses = doc.root.xpath(@contact_email_addresses)

    contact_contact_email_addresses.each do |contact_email_addresses|
      Nokogiri::XML::Builder.with(contact_email_addresses) do |xml|
        xml['auc'].ContactEmailAddress do
          xml['auc'].EmailAddress 'this.another.email@chickendinner.com'
        end
      end
    end
    contact_contact_email_addresses_contact_email_address = doc.root.xpath(@contact_email_addresses_contact_email_address)
    expect(contact_contact_email_addresses_contact_email_address.length).to eq(4)

    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end

  it 'Should not fail when multiple auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber elements are provided' do
    doc = @doc_original.clone
    contact_contact_telephone_numbers = doc.root.xpath(@contact_telephone_numbers)

    Nokogiri::XML::Builder.with(contact_contact_telephone_numbers[0]) do |xml|
      xml['auc'].ContactTelephoneNumber do
        xml['auc'].TelephoneNumber '123-456-7890'
      end
    end

    contact_contact_telephone_numbers_contact_telephone_number = doc.root.xpath(@contact_telephone_numbers_contact_telephone_number)
    expect(contact_contact_telephone_numbers_contact_telephone_number.length).to eq(3)
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'An IMPROPER con.nameEmailPhone' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/contact_name_email_phone.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @contacts_string = 'auc:Facilities/auc:Facility/auc:Contacts'
    @contact_string = @contacts_string + '/auc:Contact'
    @contact_email_addresses = @contact_string + '/auc:ContactEmailAddresses'
    @contact_email_addresses_contact_email_address = @contact_email_addresses + '/auc:ContactEmailAddress'
    @contact_telephone_numbers = @contact_string + '/auc:ContactTelephoneNumbers'
    @contact_telephone_numbers_contact_telephone_number = @contact_telephone_numbers + '/auc:ContactTelephoneNumber'
  end

  it 'Will fail and issue one ERROR for each auc:Contact element that does not have an auc:ContactName' do
    doc = @doc_original.clone
    contact_contact_name = doc.root.xpath(@contact_string + '/auc:ContactName')

    count = 0
    contact_contact_name.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(2)

    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:ContactName' is REQUIRED EXACTLY ONCE for: 'auc:Contact'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:ContactName' is REQUIRED EXACTLY ONCE for: 'auc:Contact'")
  end

  it 'Will fail and issue one ERROR for each auc:Contact element that does not have an auc:ContactEmailAddresses' do
    doc = @doc_original.clone
    contact_contact_email_addresses = doc.root.xpath(@contact_email_addresses)

    count = 0
    contact_contact_email_addresses.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(2)
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:EmailAddress' within element 'auc:ContactEmailAddresses/auc:ContactEmailAddress' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:EmailAddress' within element 'auc:ContactEmailAddresses/auc:ContactEmailAddress' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
  end

  it 'Will fail and issue one ERROR for each auc:Contact element that does not have an auc:ContactEmailAddresses/auc:ContactEmailAddress' do
    doc = @doc_original.clone
    contact_contact_email_addresses_contact_email_address = doc.root.xpath(@contact_email_addresses_contact_email_address)

    count = 0
    contact_contact_email_addresses_contact_email_address.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(2)
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:EmailAddress' within element 'auc:ContactEmailAddresses/auc:ContactEmailAddress' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:EmailAddress' within element 'auc:ContactEmailAddresses/auc:ContactEmailAddress' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
  end

  it 'Will fail and issue one ERROR for each auc:Contact element that does not have an auc:ContactEmailAddresses/auc:ContactEmailAddress/auc:EmailAddress' do
    doc = @doc_original.clone
    contact_contact_email_addresses_contact_email_address_email_address = doc.root.xpath(@contact_email_addresses_contact_email_address + '/auc:EmailAddress')

    count = 0
    contact_contact_email_addresses_contact_email_address_email_address.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(2)
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:EmailAddress' within element 'auc:ContactEmailAddresses/auc:ContactEmailAddress' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:EmailAddress' within element 'auc:ContactEmailAddresses/auc:ContactEmailAddress' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
  end

  it 'Will fail and issue one ERROR for each auc:Contact element that does not have an auc:ContactTelephoneNumbers' do
    doc = @doc_original.clone
    contact_contact_telephone_numbers = doc.root.xpath(@contact_telephone_numbers)

    count = 0
    contact_contact_telephone_numbers.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(2)
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:TelephoneNumber' within element 'auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:TelephoneNumber' within element 'auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
  end

  it 'Will fail and issue one ERROR for each auc:Contact element that does not have an auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' do
    doc = @doc_original.clone
    contact_contact_telephone_numbers_contact_telephone_number = doc.root.xpath(@contact_telephone_numbers_contact_telephone_number)

    count = 0
    contact_contact_telephone_numbers_contact_telephone_number.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(2)
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:TelephoneNumber' within element 'auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:TelephoneNumber' within element 'auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
  end

  it 'Will fail and issue one ERROR for each auc:Contact element that does not have an auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber/auc:TelephoneNumber' do
    doc = @doc_original.clone
    contact_contact_telephone_numbers_contact_telephone_number_telephone_number = doc.root.xpath(@contact_telephone_numbers_contact_telephone_number + '/auc:TelephoneNumber')

    count = 0
    contact_contact_telephone_numbers_contact_telephone_number_telephone_number.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(2)
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(2)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:TelephoneNumber' within element 'auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:TelephoneNumber' within element 'auc:ContactTelephoneNumbers/auc:ContactTelephoneNumber' is REQUIRED AT LEAST ONCE for: 'auc:Contact'")
  end
end

describe 'A PROPER con.atleastOneAuditorAndOneOwner' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/contact_atleast_one_auditor_and_one_owner.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @contacts_string = 'auc:Facilities/auc:Facility/auc:Contacts'
    @contact_string = @contacts_string + '/auc:Contact'
  end

  it "Should have, under an auc:Facility/auc:Contacts:
      Atleast two auc:Contact elements
      One auc:Contact/auc:ContactRoles/auc:ContactRole = 'Owner'
      One auc:Contact/auc:ContactRoles/auc:ContactRole = 'Energy Auditor'" do

    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end

  it 'Should not fail if more than two auc:Contact elements are specified' do
    doc = @doc_original.clone
    facility_contacts = doc.root.xpath(@contacts_string)

    facility_contacts.each do |fc|
      Nokogiri::XML::Builder.with(fc) do |xml|
        xml['auc'].Contact
      end
    end

    facility_contacts_contact = doc.root.xpath(@contact_string)
    expect(facility_contacts_contact.length).to eq(3)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER con.atleastOneAuditorAndOneOwner' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/contact_atleast_one_auditor_and_one_owner.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @contacts_string = 'auc:Facilities/auc:Facility/auc:Contacts'
    @contact_string = @contacts_string + '/auc:Contact'
    @contact_role_string = @contact_string + '/auc:ContactRoles/auc:ContactRole'
  end

  it "Will fail and issue one ERROR if there is not atleast one auc:Contact/auc:ContactRoles/auc:ContactRole='Owner'" do
    doc = @doc_original.clone
    contact_role_owner = doc.root.xpath(@contact_role_string + "[text() = 'Owner']")

    count = 0
    contact_role_owner.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(1)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Contact' with child element 'auc:ContactRoles/auc:ContactRole' with value 'Owner' is REQUIRED AT LEAST ONCE for: 'auc:Contacts’. Current number of occurrences: 0")
  end

  it "Will fail and issue one ERROR if there is not atleast one auc:Contact/auc:ContactRoles/auc:ContactRole='Energy Auditor'" do
    doc = @doc_original.clone
    contact_role_energy_auditor = doc.root.xpath(@contact_role_string + "[text() = 'Energy Auditor']")

    count = 0
    contact_role_energy_auditor.each do |el|
      el.remove
      count += 1
    end

    expect(count).to eq(1)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Contact' with child element 'auc:ContactRoles/auc:ContactRole' with value 'Energy Auditor' is REQUIRED AT LEAST ONCE for: 'auc:Contacts’. Current number of occurrences: 0")
  end

  it 'Will fail and issue three ERRORs if there are zero auc:Contact elements' do
    doc = @doc_original.clone
    contacts_contact = doc.root.xpath(@contact_string)
    expect(contacts_contact.length).to eq(2)

    count = 0
    contacts_contact.each do |el|
      el.remove
      count += 1
    end
    contacts_contact = doc.root.xpath(@contact_string)
    expect(contacts_contact.length).to eq(0)
    expect(count).to eq(2)

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(3)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:Contact' is REQUIRED AT LEAST TWICE for: 'auc:Contacts’. Current number of occurrences: 0")
    expect(errors[1][:message]).to eq("[ERROR] element 'auc:Contact' with child element 'auc:ContactRoles/auc:ContactRole' with value 'Energy Auditor' is REQUIRED AT LEAST ONCE for: 'auc:Contacts’. Current number of occurrences: 0")
    expect(errors[2][:message]).to eq("[ERROR] element 'auc:Contact' with child element 'auc:ContactRoles/auc:ContactRole' with value 'Owner' is REQUIRED AT LEAST ONCE for: 'auc:Contacts’. Current number of occurrences: 0")
  end
end

describe 'A PROPER con.notAuditorAndOwner' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/contact_not_auditor_and_owner.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @contacts_string = 'auc:Facilities/auc:Facility/auc:Contacts'
    @contact_string = @contacts_string + '/auc:Contact'
  end

  it "Should have two separate auc:Contact elements with auc:ContactRole of 'Energy Auditor' and 'Owner'" do
    doc = @doc_original.clone

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(0)
  end
end

describe 'AN IMPROPER con.notAuditorAndOwner' do
  before(:all) do
    sch_path = File.join(File.dirname(__FILE__), '../files/contact_not_auditor_and_owner.sch')
    sch_file = Nokogiri::XML File.open sch_path
    @stron = SchematronNokogiri::Schema.new sch_file

    @xml_path = File.join(File.dirname(__FILE__), '../files/good/L100_Copy.xml')
    @doc_original = Nokogiri::XML File.open @xml_path # create a Nokogiri::XML::Document
    @contacts_string = 'auc:Facilities/auc:Facility/auc:Contacts'
    @contact_string = @contacts_string + '/auc:Contact'
    @contact_roles_string = @contact_string + '/auc:ContactRoles'
  end

  it "Will fail and issue one ERROR for every auc:Contact that has an auc:ContactRole of 'Energy Auditor' and 'Owner'" do
    doc = @doc_original.clone
    contacts_contact = doc.root.xpath(@contact_string)
    expect(contacts_contact.length).to eq(2)
    contacts_contact[0].remove

    contacts_contact_contact_roles = doc.root.xpath(@contact_roles_string)
    expect(contacts_contact_contact_roles.length).to eq(1)

    Nokogiri::XML::Builder.with(contacts_contact_contact_roles[0]) do |xml|
      xml['auc'].ContactRole 'Energy Auditor'
    end

    # Begin schematron validation
    errors = @stron.validate(doc)
    # puts "Schematron errors:"
    # puts errors
    expect(errors.length).to eq(1)
    expect(errors[0][:message]).to eq("[ERROR] element 'auc:ContactRole' MUST NOT HAVE values 'Energy Auditor' and 'Owner' within 'auc:ContactRoles' for: 'auc:Contact'")
  end
end
