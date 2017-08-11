require 'rails_helper'

RSpec.describe Target, type: :model do

  it "requires either organization or name" do
    target = described_class.new()
    target.valid?
    expect(target.errors[:base]).to_not be_empty

    target.organization = "foobar.org"
    target.valid?
    expect(target.errors[:base]).to be_empty

    target.organization = nil
    target.valid?
    expect(target.errors[:base]).to_not be_empty

    target.given_name = "Foo"
    target.family_name = "Bar"
    target.valid?
    expect(target.errors[:base]).to be_empty
  end

  it "does not allow duplicate objects" do
    target_attrs = {
      organization: :Ragtag,
      given_name: :billy,
      family_name: :bob,
      ocdid: '12345678'
    }

    described_class.create!(target_attrs)
    expect { described_class.create!(target_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
  end

end
