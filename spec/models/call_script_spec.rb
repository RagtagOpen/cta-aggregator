require 'rails_helper'

RSpec.describe CallScript, type: :model do
  it "requires certain data attributes" do
    script = described_class.new()
    script.valid?
    expect(script.errors[:text]).to_not be_empty
  end

  it "assigns checksum automaticaly" do
    script = described_class.create!(text: "Lorem ipsum dolor sit amet")
    expect(script.checksum).to_not be_nil
  end

  it "updates checksum when text changes" do
    script = described_class.create!(text: "Lorem ipsum dolor sit amet")
    original_checksum = script.checksum
    script.update_attributes(text: "Hello world!")
    
    expect(script.checksum).to_not eq original_checksum
  end

  it "validates uniqueness of text" do
    text = "Lorem ipsum dolor sit amet"

    described_class.create!(text: text)

    expect { described_class.create!(text: text) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
