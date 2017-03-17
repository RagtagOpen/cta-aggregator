require 'rails_helper'

RSpec.describe Location, type: :model do
  it "contians all necessary data attributes" do
    location = described_class.new()
    location.valid?
    expect((location.errors[:address_line1]).size).to eq(1)
    expect((location.errors[:city]).size).to eq(1)
    expect((location.errors[:state]).size).to eq(1)
    expect((location.errors[:postal_code]).size).to eq(1)
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
