require 'rails_helper'

RSpec.describe Contact, type: :model do

  it "requires certain data attributes" do
    contact = described_class.new()
    contact.valid?
    expect(contact.errors[:name]).to_not be_empty
  end

  it "validates format of email" do
    contact = described_class.new(name: :foobar)
    ['bad_email', 'bad_email@example', 'bad_email.com'].each do |email|
      contact.email = email
      contact.valid?
      expect((contact.errors[:email]).size).to eq(1)
    end
  end

  it "validates uniqueness of email" do
    email = "foo@example.com"
    described_class.create!(email: email, name: "foo bar")

    expect { described_class.create!(email: email, name: "fizz buzz") }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "validates email or phone present" do
    contact = described_class.new(name: :foobar)
    contact.valid?
    expect((contact.errors[:phone_or_email]).size).to eq(1)
  end
end
