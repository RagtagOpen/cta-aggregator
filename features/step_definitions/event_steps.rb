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
  data.each { |item| validate_call_to_action(item["attributes"]) }
end

############# given

Given(/^the system contains the following events:$/) do |table|
  table.hashes.each do |hsh|
    event = Event.where(
      title: hsh["title"],
      description: hsh["description"],
      free: hsh["free"],
      start_at: hsh["start_at"],
      end_at: hsh["end_at"],
      website: hsh["website"],
      action_type: Event::CTA_TYPES[hsh["event_type"].to_sym],
      location_id: hsh["location_id"]
    ).first_or_create
    if hsh["uuid"]
      event.update_attributes(id: hsh["uuid"])
    end
  end
end
Given(/^the system contains an? event with uuid "([^"]*)"$/) do |uuid|
  event = Event.where(
    title: :foobar,
    description: :desc,
    website: "www.example.com",
    action_type: 2,
    start_at: DateTime.strptime('17524896000', '%s'),
    end_at:  DateTime.strptime('17524910400', '%s')
  ).first_or_create
  event.update_attributes(id: uuid)
end


########### when
When(/^the client requests the event with uuid "([^"]*)"$/) do |uuid|
  get("events/#{uuid}", @body, @headers)
end


