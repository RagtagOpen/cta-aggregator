FactoryGirl.define do
  factory :event do
    sequence(:title) { |n| "#{['March on Washington', 'Sit in at your Senators office'].sample} - #{n}" }
    description Faker::Lorem.sentence
    browser_url { Faker::Internet.url('example.com') }
    origin_system "Emily's List"
    identifiers { [ "emilyslist:rec#{SecureRandom.hex(7)}" ] }
    featured_image_url { Faker::LoremPixel.image }
    start_date { [1,2,3].sample.days.from_now }
    end_date { [4,5,6].sample.days.from_now }
    free { [true, false].sample }
    location { create(:location) }
    share_url { Faker::Internet.url('shareablecontent.com') }

    trait :free do
      free true
    end

    trait :paid do
      free false
    end
  end
end
