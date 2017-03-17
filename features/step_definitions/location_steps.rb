############ helpers

def validate_location(attrs)
# binding.pry
  expect(attrs["address-line1"]).to be_a_kind_of(String)
end

############# given

Given(/^I send and accept JSON$/) do
  @headers = { 'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => 'application/vnd.api+json'}
end

Given(/^the system contains the following locations:$/) do |table|
  table.hashes.each do |hsh|

		foo = Location.where(
			address_line1: hsh[:address_line1],
			address_line2: hsh[:address_line2],
			city: hsh[:city],
			state: hsh[:state],
			postal_code: hsh[:postal_code],
			notes: hsh[:notes]
		).first_or_create
		#binding.pry
		foo
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

When(/^the client requests a list of locations$/) do
  get("/locations")
end

When(/^I send a GET request to "([^"]*)"$/) do |endpoint|
 	# FIXME: remove duplicatation with post method
  get endpoint, @body,  @headers
end

############# then

Then(/^the response contains an array with (#{CAPTURE_INT}) (.*?)s?$/) do |count, resource_type|
  response_body  = MultiJson.load(last_response.body)
  expect(response_body["data"].count).to eq count
  validate_element(response_body["data"].first, of: resource_type)
end

Then(/^the response status should be "([^"]*)"$/) do |status|
  expect(last_response.status).to eq status
end

Then(/^one location has the following attributes:$/) do |table|
  expected_attrs = table.hashes.each_with_object({}) do |row, hash|
    name, value, type = row["attribute"], row["value"], row["type"]
    hash[name.tr(" ", "_").camelize(:lower)] = value_to_type(value, type) 
  end

  data = MultiJson.load(last_response.body)["data"]

  expect(data["attributes"]).to eq expected_attrs
end

Then(/^one location has a "([^"]*)" attribute of "([^"]*)"$/) do |attr, expected_attr|
  data = MultiJson.load(last_response.body)["data"]

  matched_item = data.select { |datum| datum["attributes"][attr.dasherize] == expected_attr }

  expect(matched_item).to_not be_empty
end
