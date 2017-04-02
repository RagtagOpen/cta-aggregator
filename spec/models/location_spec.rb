require 'rails_helper'

RSpec.describe Location, type: :model do
  it "invalid when missing address" do
    loc = described_class.new()
    loc.valid?
    expect(loc.errors[:address]).to be_present
  end

  it "invalid when missing city, state and zip" do
    loc = described_class.new(address: "123 Fake St.")
    loc.valid?

    expect(loc.errors[:location]).to eq ['requires city and state or zipcode']
  end

  it "invalid with address and city" do
    loc = described_class.new(address: "123 Fake St.",
                              city: "Milwaukee")
    loc.valid?

    expect(loc.errors[:location]).to eq ["requires city and state or zipcode"]
  end

  it "valid with address, city, state, and zipcode" do
    loc = described_class.new(address: "123 Fake St.",
                              city: "Milwaukee",
                              state: "WI",
                              zipcode: "53172")
    expect(loc.valid?).to be true
  end

  it "valid with address, city and state" do
    loc = described_class.new(address: "123 Fake St.",
                              city: "Milwaukee",
                              state: "WI")
    expect(loc.valid?).to be true
  end

  it "valid with address and zipcode" do
    loc = described_class.new(address: "123 Fake St.",
                              zipcode: "53172")
    expect(loc.valid?).to be true
  end

  it "validates uniqueness of location" do
    location_attrs = {address: "123 Fake St.",
                      city: "Bannock",
                      state: "ID",
                      zipcode: "83234" }
    described_class.create!(location_attrs)
    loc = described_class.new(location_attrs)

    loc.valid?

    expect(loc.errors[:location]).to eq ['already exists']
  end

end
