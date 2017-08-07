FactoryGirl.define do

  factory :advocacy_campaign do
    sequence(:title) { |n| "#{['Call Congressman', "Email Congressman"].sample} - #{n}" }
    description { Faker::Lorem.sentence }
    browser_url { Faker::Internet.url('example.com') }
    origin_system '5Calls'
    identifier { "5calls:rec#{SecureRandom.hex(7)}" }
    featured_image_url { Faker::LoremPixel.image }
    action_type { ['email', 'in-person', 'phone', 'postal mail'].sample }
    template { Faker::Lorem.paragraphs.join("\n") }

    transient do
      target_count 0
    end

    after(:build) do |advocacy_campaign|
      advocacy_campaign.identifiers = [advocacy_campaign.identifier]
    end

    trait :with_targets do
      before(:create) do |advocacy_campaign, evaluator|
        evaluator.target_count.to_i.times do
          advocacy_campaign.target_list << build(:target)
        end
      end
    end
  end

end
