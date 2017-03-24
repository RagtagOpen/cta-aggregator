require 'rails_helper'

RSpec.describe Event, type: :model do
  it "requires certain data attributes" do
    event = described_class.new()
    event.valid?
    expect(event.errors[:title]).to_not be_empty
    expect(event.errors[:description]).to_not be_empty
    expect(event.errors[:website]).to_not be_empty
    expect(event.errors[:start_at]).to_not be_empty
    expect(event.errors[:end_at]).to_not be_empty
    expect(event.errors[:event_type]).to_not be_empty
  end

  it "#event_type" do
    described_class::CTA_TYPES.each do |key, value|
      event = described_class.create!(title: :foo, description: :desc, website: 'www.example.com', start_at: DateTime.now, end_at: DateTime.now, event_type: key)

      expect(event.action_type).to eq value
    end
  end

  it "does not allow duplicate objects" do
    event_attrs = {title: :foo,
                   description: :desc,
                   website: 'www.example.com',
                   start_at: DateTime.now,
                   end_at: DateTime.now,
                   event_type: :onsite}
    described_class.create!(event_attrs)
    expect { described_class.create!(event_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
