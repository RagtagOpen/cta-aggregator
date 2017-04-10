Given(/^the system contains the following users:$/) do |table|
  table.hashes.each do |hash|
    User.where(email: hash[:email]).first || User.create!(hash)
  end
end

Then(/^the response contains a JWT for a user with email (.*?)$/) do |email|
  user = User.find_by(email: email)
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  data = MultiJson.load(last_response.body)
  expect(data['jwt']).to eq(token)
end
