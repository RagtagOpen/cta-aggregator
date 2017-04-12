require 'rails_helper'

RSpec.describe CTA, type: :model do

  it "requires certain data attributes" do
    cta = described_class.new()
    cta.valid?
    expect(cta.errors[:title]).to_not be_empty
    expect(cta.errors[:description]).to_not be_empty
    expect(cta.errors[:website]).to_not be_empty
    expect(cta.errors[:start_at]).to_not be_empty
    expect(cta.errors[:cta_type]).to_not be_empty
  end

  it "#cta_type" do
    described_class::CTA_TYPES.each do |key, value|
      cta = described_class.create!(title: :foo, description: :desc, website: 'www.example.com', start_at: DateTime.now, end_at: DateTime.now, cta_type: key)

      expect(cta.action_type).to eq value
    end
  end

  it "does not allow duplicate objects" do
    cta_attrs = {title: :foo,
                   description: :desc,
                   website: 'www.example.com',
                   start_at: DateTime.now,
                   end_at: DateTime.now,
                   cta_type: :onsite}
    described_class.create!(cta_attrs)
    expect { described_class.create!(cta_attrs) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
