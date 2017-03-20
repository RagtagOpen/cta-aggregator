############# Helpers

def validate_call_to_action(attrs)
  expect(attrs["title"]).to be_a_kind_of(String) if attrs["title"]
  expect(attrs["description"]).to be_a_kind_of(String) if attrs["description"]
  expect(attrs["website"]).to be_a_kind_of(String) if attrs["website"]
  expect(attrs["event_type"]).to be_a_kind_of(String) if attrs["event_type"]
  expect(attrs["start_at"]).to be_a_kind_of(DataTime) if attrs["start_at"]
  expect(attrs["end_at"]).to be_a_kind_of(String) if attrs["end_at"]
end

def validate_calls_to_action(data, count: nil)
  expect(data).to be_a_kind_of(Array)
  expect(data.count).to eq(count) unless count.nil?
  data.each { |item| validate_call_to_action(item["attributes"]) }
end

############# given

Given(/^the system contains the following calls to action:$/) do |table|
  table.hashes.each do |hsh|
    CallToAction.where(
      title: hsh["title"],
      description: hsh["description"],
      free: hsh["free"],
      start_at: hsh["start_at"],
      end_at: hsh["end_at"],
      website: hsh["website"],
      action_type: CallToAction::CTA_TYPES[hsh["event_type"].to_sym],
      location_id: hsh["location_id"]
    ).first_or_create
  end
end

Given(/^the system contains a call to action with uuid "([^"]*)"$/) do |uuid|
  cta = CallToAction.where(
    title: :foobar,
    description: :desc,
    website: "www.example.com",
    action_type: 2,
    start_at: DateTime.strptime('17524896000', '%s'),
    end_at:  DateTime.strptime('17524910400', '%s')
  ).first_or_create
  cta.update_attributes(id: uuid)
end

############# when

When(/^the client requestes the call to action containing the title "([^"]*)"$/) do |title|
  # FIXME: this is fragile.  Doesn't address duplicate titles.
  cta = CallToAction.where(title: title).first
  get("/call_to_actions/#{cta.id}")
end

When(/^the client requests the list of calls to action$/) do
  get("/call_to_actions")
end

############# then

Then(/^the response contains one call to action$/) do
  response_body  = MultiJson.load(last_response.body)

  validate_call_to_action(response_body["data"])
end

Then(/^the response will contain (#{CAPTURE_INT}) calls? to action$/) do |count|
  response_body  = MultiJson.load(last_response.body)

  if count == 1
    validate_call_to_action(response_body["data"])
  else 
    validate_calls_to_action(response_body["data"], count: count)
  end
end

Then(/^one call to action has a the a "([^"]*)" attributes of "([^"]*)"$/) do |attr, expected_attr|
  data = MultiJson.load(last_response.body)["data"]

  matched_item = data.select { |datum| datum["attributes"][attr] == expected_attr }

  expect(matched_item).to_not be_empty
end


Then(/^one call to action has the following attributes:$/) do |table|
  expected_attrs = table.hashes.each_with_object({}) do |row, hash|
    name, value, type = row["attribute"], row["value"], row["type"]
    hash[name.tr(" ", "_").camelize(:lower)] = value_to_type(value, type) 
  end

  data = MultiJson.load(last_response.body)["data"]

  expect(data["attributes"]).to eq expected_attrs
end
