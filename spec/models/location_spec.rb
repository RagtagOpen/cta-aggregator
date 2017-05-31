require 'rails_helper'

RSpec.describe Location, type: :model do
  it "invalid when missing address" do
    loc = described_class.new()
    loc.valid?
    expect(loc.errors[:address_lines]).to be_present
  end

  it "invalid when missing locality, region and postal_code" do
    loc = described_class.new(address_lines: "123 Fake St.")
    loc.valid?

    expect(loc.errors[:location]).to eq ['requires locality and region or postal_code']
  end

  it "invalid with address and locality" do
    loc = described_class.new(address_lines: "123 Fake St.",
                              locality: "Milwaukee")
    loc.valid?

    expect(loc.errors[:location]).to eq ["requires locality and region or postal_code"]
  end

  it "valid with address, locality, region, and postal_code" do
    loc = described_class.new(address_lines: "123 Fake St.",
                              locality: "Milwaukee",
                              region: "WI",
                              postal_code: "53172")
    expect(loc.valid?).to be true
  end

  it "valid with address, locality and region" do
    loc = described_class.new(address_lines: "123 Fake St.",
                              locality: "Milwaukee",
                              region: "WI")
    expect(loc.valid?).to be true
  end

  it "valid with address and postal_code" do
    loc = described_class.new(address_lines: "123 Fake St.",
                              postal_code: "53172")
    expect(loc.valid?).to be true
  end

  it "validates uniqueness of location" do
    location_attrs = {address_lines: "123 Fake St.",
                      locality: "Bannock",
                      region: "ID",
                      postal_code: "83234" }
    described_class.create!(location_attrs)
    loc = described_class.new(location_attrs)

    loc.valid?

    expect(loc.errors[:location]).to eq ['already exists']
  end

  it "validates size of region abbreviation" do
    location_attrs = { address_lines: "123 Fake St.",
                       locality: "Bannock",
                       region: "Idaho",
                       postal_code: "83234" }
    loc = described_class.new(location_attrs)
    loc.valid?
    expect(loc.errors[:region]).to be_present
  end
end
