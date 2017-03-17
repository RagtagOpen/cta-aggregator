############ helpers

def validate_contact(attrs)
  # FIXME: are these really meaningful expectations?
  expect(attrs["email"]).to be_a_kind_of(String)
  expect(attrs["name"]).to be_a_kind_of(String) if attrs["name"]
  expect(attrs["phone"]).to be_a_kind_of(String) if attrs["phone"]
  expect(attrs["website"]).to be_a_kind_of(String) if attrs["website"]
end

Given(/^the system contains the following contacts:$/) do |table|
  table.hashes.each do |hsh|
		Contact.where(
			name: hsh[:name],
			phone: hsh[:phone],
			email: hsh[:email],
			website: hsh[:website]
		).first_or_create
  end
end

