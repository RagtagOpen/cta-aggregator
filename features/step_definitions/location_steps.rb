############ helpers

def validate_location(attrs)
  expect(attrs["address-line1"]).to be_a_kind_of(String)
  expect(attrs["address-line2"]).to be_a_kind_of(String) if attrs["address-line2"]
  expect(attrs["city"]).to be_a_kind_of(String)
  expect(attrs["state"]).to be_a_kind_of(String)
  expect(attrs["postal-code"]).to be_a_kind_of(String)
  expect(attrs["notes"]).to be_a_kind_of(String) if attrs["notes"]
end

############# given

Given(/^I send and accept JSON$/) do
  @headers = { 'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => 'application/vnd.api+json'}
end

Given(/^the system contains the following locations:$/) do |table|
  table.hashes.each do |hsh|
		Location.where(
			address_line1: hsh[:address_line1],
			address_line2: hsh[:address_line2],
			city: hsh[:city],
			state: hsh[:state],
			postal_code: hsh[:postal_code],
			notes: hsh[:notes]
		).first_or_create
  end
end

############# when

When(/^I set JSON request body to:$/) do |body|
   #@body = JSON.dump(JSON.parse(body))
  #@body = JSON.parse body
   @body = body
end

When(/^I send a POST request to "([^"]*)"$/) do |endpoint|
  post endpoint, @body,  @headers
end

When(/^I send a GET request to "([^"]*)"$/) do |endpoint|
 	# FIXME: remove duplicatation with post method
  get endpoint, @body,  @headers
end
