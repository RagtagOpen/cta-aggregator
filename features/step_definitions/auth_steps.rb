Given(/^the system contains the following users:$/) do |table|
  table.hashes.each do |hash|
    User.where(email: hash[:email]).first || User.create!(hash)
  end
end

Given(/^the client sets a malformed JWT in the authorization header$/) do
  token = "#{SecureRandom.uuid.gsub("-","_")}.#{SecureRandom.uuid.gsub("-","_")}"
  @headers['HTTP_AUTHORIZATION'] = "Bearer #{token}"
end

When(/^the token expires$/) do
  Timecop.freeze(DateTime.current + Knock.token_lifetime + 1.hour)
end

Then(/^the response contains a JWT for a user with email (.*?)$/) do |email|
  user = User.find_by(email: email)
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  data = MultiJson.load(last_response.body)
  expect(data['jwt']).to eq(token)
end
