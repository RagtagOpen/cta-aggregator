############ helpers

def validate_location(attrs)
  expect(attrs["address-line-1"]).to be_a_kind_of(String)
  expect(attrs["address-line-2"]).to be_a_kind_of(String) if attrs["address-line-2"]
  expect(attrs["city"]).to be_a_kind_of(String)
  expect(attrs["state"]).to be_a_kind_of(String)
  expect(attrs["zipcode"]).to be_a_kind_of(String)
  expect(attrs["notes"]).to be_a_kind_of(String) if attrs["notes"]
end

############# given
Given(/^the system contains the following locations:$/) do |table|
  table.hashes.each do |hsh|
		Location.where(
			address_line_1: hsh[:address_line_1],
			address_line_2: hsh[:address_line_2],
			city: hsh[:city],
			state: hsh[:state],
			zipcode: hsh[:zipcode],
			notes: hsh[:notes]
		).first_or_create
  end
end

Given(/^the system contains a location with uuid "([^"]*)"$/) do |uuid|
  location = Location.where(
    address_line_1: "123 Fake St.",
    city: "Fakeville",
    state: "OR",
    zipcode: "12345"
  ).first_or_create
  location.update_attributes(id: uuid)
end

