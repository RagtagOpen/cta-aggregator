require 'rails_helper'

RSpec.describe Event, type: :model do
  it "requires certain data attributes" do
    event = described_class.new()
    event.valid?
    expect(event.errors[:title]).to_not be_empty
    expect(event.errors[:browser_url]).to_not be_empty
    expect(event.errors[:origin_system]).to_not be_empty
    expect(event.errors[:start_date]).to_not be_empty
  end

  it "does not allow duplicate objects" do
    event = create(:event)

    event_attrs = event.attributes.except(:id, :created_at, :updated_at)

    expect { described_class.create!(event_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
