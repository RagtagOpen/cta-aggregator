FactoryGirl.define do
  factory :location do
    venue { Faker::University.name }
    address_lines { [Faker::Address.street_address, Faker::Address.secondary_address] }
    locality { Faker::Address.city }
    region { Faker::Address.state_abbr }
    postal_code { Faker::Address.postcode }
  end
end
