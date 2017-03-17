############# Helpers
CAPTURE_INT = Transform(/^(?:-?\d+|zero|one|two|three|four|five|six|seven|eight|nine|ten)$/) do |v|
    %w(zero one two three four five six seven eight nine ten).index(v) || v.to_i
end

def value_to_type(input, expected_type)
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

############ then

Then(/^the response contains (#{CAPTURE_INT}) (.*?)s?$/) do |count, resource_type|
  response_body  = MultiJson.load(last_response.body)

  if count == 1
    validate_element(response_body["data"], of: resource_type, count: count)
  else
    validate_list(response_body["data"], of: resource_type, count: count)
  end
end





Then(/^the response contains (#{CAPTURE_INT}) (.*?)s?$/) do |count, resource_type|
  response_body  = MultiJson.load(last_response.body)

  if count == 1
    validate_element(response_body["data"], of: resource_type, count: count)
  else
    validate_list(response_body["data"], of: resource_type, count: count)
  end
end
