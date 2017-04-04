############# Helpers

def validate_event(attrs)
  expect(attrs["title"]).to be_a_kind_of(String) if attrs["title"]
  expect(attrs["description"]).to be_a_kind_of(String) if attrs["description"]
  expect(attrs["website"]).to be_a_kind_of(String) if attrs["website"]
  expect(attrs["event_type"]).to be_a_kind_of(String) if attrs["event_type"]
  expect(attrs["start_at"]).to be_a_kind_of(DataTime) if attrs["start_at"]
  expect(attrs["end_at"]).to be_a_kind_of(String) if attrs["end_at"]
end

def validate_events(data, count: nil)
  expect(data).to be_a_kind_of(Array)
  expect(data.count).to eq(count) unless count.nil?
  data.each { |item| validate_event(item["attributes"]) }
end

############# given

Given(/^the system contains the following ctas:$/) do |table|
  table.hashes.each do |hsh|
    cta = CTA.where(
      title: hsh["title"],
      description: hsh["description"],
      free: hsh["free"],
      start_at: hsh["start_at"],
      end_at: hsh["end_at"],
      website: hsh["website"],
      action_type: Event::CTA_TYPES[hsh["cta_type"].to_sym],
      location_id: hsh["location_id"]
    ).first_or_create
    if hsh["uuid"]
      cta.update_attributes(id: hsh["uuid"])
    end
  end
end

Given(/^the system contains a cta with uuid "([^"]*)"$/) do |uuid|
  cta = CTA.where(
    title: :foobar,
    description: :desc,
    website: "www.example.com",
    action_type: 2,
    start_at: DateTime.strptime('17524896000', '%s'),
    end_at:  DateTime.strptime('17524910400', '%s')
  ).first_or_create
  cta.update_attributes(id: uuid)
end

########### then

Then(/^the cta has an? ([^"]*) of "([^"]*)"$/) do |attr_name, attr_value|
  id = MultiJson.load(last_response.body)["data"]["id"]
  cta = CTA.find(id)
  expect(cta.send(attr_name.to_sym)).to eq attr_value
end
