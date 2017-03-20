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

Given(/^the system contains a location with uuid "([^"]*)"$/) do |uuid|
  location = Location.where(
    address_line1: "123 Fake St.",
    city: "Fakeville",
    state: "OR",
    postal_code: "12345"
  ).first_or_create
  location.update_attributes(id: uuid)
end

