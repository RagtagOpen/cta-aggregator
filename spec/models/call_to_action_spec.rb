require 'rails_helper'

RSpec.describe CallToAction, type: :model do

  it "requires certain data attributes" do
    cta = described_class.new()
    cta.valid?
    expect(cta.errors[:title]).to_not be_empty
    expect(cta.errors[:description]).to_not be_empty
    expect(cta.errors[:website]).to_not be_empty
    expect(cta.errors[:start_at]).to_not be_empty
    expect(cta.errors[:end_at]).to_not be_empty
    expect(cta.errors[:event_type]).to_not be_empty
  end

  it "#event_type" do
    described_class::CTA_TYPES.each do |key, value|
      contact = described_class.create!(title: :foo, description: :desc, website: 'www.example.com', start_at: DateTime.now, end_at: DateTime.now, event_type: key)

      expect(contact.action_type).to eq value
    end
  end

  it "does not allow duplicate objects" do
    contact = described_class.new(title: :foo, description: :desc, website: 'www.example.com', start_at: DateTime.now, end_at: DateTime.now, event_type: :onsite)
    contact.save!
    expect { contact.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
