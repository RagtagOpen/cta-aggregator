# 01_ in filename ensures this file will be loaded before all other step files

############# Helpers
CAPTURE_INT = Transform(/^(?:-?\d+|zero|one|two|three|four|five|six|seven|eight|nine|ten)$/) do |v|
    %w(zero one two three four five six seven eight nine ten).index(v) || v.to_i
end

def value_to_type(input, expected_type)
  return nil if input.blank?
  case 
  when expected_type.constantize == DateTime
    DateTime.parse(input)
  when expected_type.constantize == String
    input.to_s
  when expected_type.constantize == Integer
    input.to_i
  when expected_type.constantize == FalseClass
    value_to_boolean(input)
  when expected_type.constantize == TrueClass
    value_to_boolean(input)
  end
end

def value_to_boolean(input)
  (input =~ /true/i) == 0 ? true : false
end

def validate_list(data, of: nil, count: nil)
  expect(data).to be_a_kind_of(Array)
  expect(data.count).to eq(count) unless count.nil?
end

def validate_element(data, of: nil)
  unless of.nil?
    validate_item = "validate_#{of.singularize.downcase.tr(' ', '_')}".to_sym
    send(validate_item, data["attributes"])
  end
end

########### given

Given(/^the client sends and accepts JSON$/) do
  @headers = { 'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => 'application/vnd.api+json'}
end

########### when

When(/^the client sets the JSON request body to:$/) do |body|
   @body = body
end

When(/^the client sends a (GET|POST|PATCH|PUT|DELETE) request to "(.*?)"$/) do |method, path|
  # automatically prepending v1 here to keep code DRY.  Not sure if this is the best approach.
  case method
  when 'GET'
    get("v1/#{path}", @body)
  when 'POST'
    post("v1/#{path}", @body, @headers)
  when 'PATCH'
    patch("v1/#{path}", @body, @headers)
  when 'PUT'
    put("v1/#{path}", @body, @headers)
  when 'DELETE'
    delete("v1/#{path}", @headers)
  end
  @body = nil
  @header = nil
end

############ then

Then(/^the response contains (#{CAPTURE_INT}) (.*?)s?$/) do |count, resource_type|
  response_body  = MultiJson.load(last_response.body)

  if count == 1
    # FIXME: will throw false positive if response has only 1 object in is meant to.
    validate_element(response_body["data"], of: resource_type)
  else
    validate_list(response_body["data"], of: resource_type, count: count)
  end
end

Then(/^the response contains an? "([^"]*)" attribute of "([^"]*)"$/) do | attr, expected_attr |

  data = MultiJson.load(last_response.body)["data"]

  matched_item = data.select { |datum| datum["attributes"][attr.dasherize] == expected_attr }

  expect(matched_item).to_not be_empty
end

Then(/^the response contains the following attributes:$/) do |table|
  expected_attrs = table.hashes.each_with_object({}) do |row, hash|
    name, value, type = row["attribute"], row["value"], row["type"]
    hash[name.tr(" ", "_").camelize(:lower)] = value_to_type(value, type)
  end

  data = MultiJson.load(last_response.body)["data"]

  expect(data["attributes"]).to eq expected_attrs
end

Then(/^the response contains an array with (#{CAPTURE_INT}) (.*?)s?$/) do |count, resource_type|
  response_body  = MultiJson.load(last_response.body)
  expect(response_body["data"].count).to eq count
  validate_element(response_body["data"].first, of: resource_type)
end

Then(/^the response status should be "([^"]*)"$/) do |status|
  expect(last_response.status).to eq status
end

