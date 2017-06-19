FactoryGirl.define do
  factory :target do
    organization { Faker::Company.name }
    given_name { Faker::Name.first_name }
    family_name { Faker::Name.last_name }
    ocdid { SecureRandom.uuid }

    postal_addresses do [{
        primary: true,
        address_type: 'Office',
        venue: Faker::University.name,
        address_lines: [Faker::Address.street_address, Faker::Address.secondary_address],
        locality: Faker::Address.city,
        region: Faker::Address.state_abbr,
        postal_code: Faker::Address.postcode,
        country: 'US'
      }]
    end

    email_addresses do
        [{
        primary: true,
        address: Faker::Internet.email,
        address_type: 'work',
        status: nil
      }]
    end

    phone_numbers do
      [{
        primary: true,
        number: Faker::PhoneNumber.phone_number,
        extension: Faker::PhoneNumber.extension,
        number_type: 'work'
      }]
    end
  end
end
