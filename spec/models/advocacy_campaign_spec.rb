require 'rails_helper'

RSpec.describe AdvocacyCampaign, type: :model do

  it "requires certain data attributes" do
    advocacy_campaign = described_class.new()
    advocacy_campaign.valid?
    expect(advocacy_campaign.errors[:title]).to_not be_empty
    expect(advocacy_campaign.errors[:description]).to_not be_empty
    expect(advocacy_campaign.errors[:browser_url]).to_not be_empty
    expect(advocacy_campaign.errors[:origin_system]).to_not be_empty
    expect(advocacy_campaign.errors[:action_type]).to_not be_empty
  end

  it "does not allow duplicate objects" do
    advocacy_campaign_attrs = {
      title: :foo,
      description: :desc,
      browser_url: 'www.example.com',
      origin_system: 'Five Calls',
      action_type: :onsite
    }

    described_class.create!(advocacy_campaign_attrs)
    expect { described_class.create!(advocacy_campaign_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
  end

end
