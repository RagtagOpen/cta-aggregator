require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:password) { SecureRandom.uuid }
  let(:user_attributes) {
    {
      email: "foo@example.com",
      password: password,
      password_confirmation: password
    }
  }
  describe "#save" do
    let(:user) { described_class.new(user_attributes) }
    describe "api key generation" do
      context "given a valid user" do
        it "creates a uuid for the api key" do
          expect(user.api_key).not_to be_present
          user.save
          expect(user.api_key).to be_present
        end
      end
    end
  end

  describe "#authenticate" do
    let(:user) { described_class.new(user_attributes) }
    context "given the correct secret key" do
      it "returns the user" do
        expect(user.authenticate(password)).to eq(user)
      end
    end

    context "given the incorrect secret_key" do
      it "returns false" do
        expect(user.authenticate("not the secret key")).to be_falsey
      end
    end
  end

  describe "#valid?" do
    let(:user) { described_class.new(user_attributes) }
    context "given the presence of an email and password" do
      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "given the absence of an email" do
      let(:user) { described_class.new(user_attributes.except(:email)) }
      it "is invalid" do
        expect(user).not_to be_valid
        expect(user.errors.details[:email]).to match(a_collection_including(a_hash_including(error: :blank)))
      end
    end

    context "given the absence of an password" do
      let(:user) { described_class.new(user_attributes.except(:password)) }
      it "is invalid" do
        expect(user).not_to be_valid
        expect(user.errors.details[:password]).to match(a_collection_including(a_hash_including(error: :blank)))
      end
    end

    context "given a pre-existing email" do
      let(:user) { described_class.new(user_attributes) }

      before do
        described_class.create!(user_attributes)
      end

      it "is invalid" do
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
        expect(user.errors.details[:email]).to match(a_collection_including(a_hash_including(error: :taken)))
      end
    end
  end

  describe ".from_token_request" do
    let!(:user_one) { described_class.create!(user_attributes) }
    let!(:user_two) {
      described_class.create!(
        user_attributes.merge(email: "footwo@example.com")
      )
    }
    let(:user_one_api_key) { user_one.api_key }
    let(:fake_user_one_request) {
      double(authorization: "#{user_one_api_key}:it doesn't matter")
    }

    context "given a user's api key" do
      let(:query) { User.from_token_request(fake_user_one_request) }
      it "returns the correct user" do
        expect(query).to eq(user_one)
      end

      it "does not return the incorrect user" do
        expect(query).not_to eq(user_two)
      end
    end

    context "given an invalid key" do
      let(:fake_request) {
        double(authorization: "something impossible:it doesn't matter")
      }

      let(:query) { User.from_token_request(fake_request) }
      it "returns nil" do
        expect(query).not_to be_present
      end
    end
  end
end
