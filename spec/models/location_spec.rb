require 'rails_helper'

RSpec.describe Location, type: :model do
  it "requires certain data attributes" do
    location = described_class.new()
    location.valid?
    expect(location.errors[:address]).to_not be_empty
    expect(location.errors[:city]).to_not be_empty
    expect(location.errors[:state]).to_not be_empty
    expect(location.errors[:zipcode]).to_not be_empty
  end

  it "validates uniqueness of location" do
    location_attrs = {address: "123 Fake St.",
                      city: "Bannock",
                      state: "ID",
                      zipcode: "83234" }
    described_class.create!(location_attrs)
    expect { described_class.create!(location_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
