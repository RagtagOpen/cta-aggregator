############ helpers

def validate_scripte(attrs)
  expect(attrs["text"]).to be_a_kind_of(String)
end

########### given

Given(/^the system contains the following call scripts:$/) do |table|
  table.hashes.each do |hsh|
		CallScript.where(
			text: hsh[:text],
		).first_or_create
  end
end

Given(/^the system contains a call script with uuid "([^"]*)"$/) do |uuid|
  script = CallScript.create!(
    text: "Lorem ipsum dolor sit amet"
  )
  script.update_attributes(id: uuid)
end
