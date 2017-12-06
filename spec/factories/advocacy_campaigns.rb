FactoryGirl.define do

  factory :advocacy_campaign do
    sequence(:title) { |n| "#{['Call Congressman', "Email Congressman"].sample} - #{n}" }
    description { Faker::Lorem.sentence }
    browser_url { Faker::Internet.url('example.com') }
    origin_system '5Calls'
    identifiers { [ "5calls:rec#{SecureRandom.hex(7)}" ] }
    featured_image_url { Faker::LoremPixel.image }
    action_type { ['email', 'in-person', 'phone', 'postal mail'].sample }
    template { Faker::Lorem.paragraphs.join("\n") }
    user_id { SecureRandom.uuid }
    share_url { Faker::Internet.url('shareablecontent.com') }

    transient do
      target_count 0
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
