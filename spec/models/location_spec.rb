require 'rails_helper'

RSpec.describe Location, type: :model do
  it "requires certain data attributes" do
    location = described_class.new()
    location.valid?
    expect(location.errors[:address_line1]).to_not be_empty
    expect(location.errors[:city]).to_not be_empty
    expect(location.errors[:state]).to_not be_empty
    expect(location.errors[:postal_code]).to_not be_empty
  end

  it "validates uniqueness of location" do
    location = described_class.new(
        address_line1: "123 Fake St.",
        city: "Bannock",
        state: "ID",
        postal_code: "83234"
    )
    location.save!
    expect { location.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
