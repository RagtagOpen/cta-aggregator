require 'rails_helper'

class QuietLogger
  def self.log(_)
    # ssh!
  end
end

class FakeLogger
  @@messages = []
  def self.log(message)
    @@messages << message
  end

  def self.messages
    @@messages
  end

  def self.messages=(val)
    @@messages = val
  end

  def self.reset!
    @@messages = []
  end
end

class FakeRandomizer
  def self.uuid
    "foo-bar"
  end
end

describe UserCreationService, type: :service do
  describe "#save" do
    let(:service) { UserCreationService.new(params, QuietLogger) }
    context "given a valid user" do
      let(:params) { { email: "foo@example.com" } }

      it "returns true" do
        expect(service.save).to be_truthy
      end

      context "password generation" do
        context "logging" do
          let(:service) { UserCreationService.new(params, FakeLogger, FakeRandomizer) }

          after(:each) do
            FakeLogger.reset!
          end

          it "creates a random unencrypted api secret without dashes and logs it" do
            service.save
            expect(FakeLogger.messages).to include("API SECRET: foobar")
          end

          it "logs the api_key" do
            service.save
            expected_api_key = User.last.api_key
            expect(FakeLogger.messages).to include("API KEY: #{expected_api_key}")
          end
        end
      end
    end

    context "given an invalid user" do
      let(:params) { { email: nil } }

      it "returns false" do
        expect(service.save).to be false
      end

      context "logging" do
        let(:service) { UserCreationService.new(params, FakeLogger, FakeRandomizer) }

        after(:each) do
          FakeLogger.reset!
        end

        it "logs errors" do
          service.save
          expect(FakeLogger.messages).to include("Email can't be blank")
        end
      end
    end
  end
end
