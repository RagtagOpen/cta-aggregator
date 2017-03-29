require "token_request"
require "spec_helper"

describe TokenRequest do
  context "given a request with an authorization header in the format of key:secret" do
    let(:key) { "foo" }
    let(:secret) { "bar" }
    let(:request) { OpenStruct.new(authorization: "#{key}:#{secret}") }
    let(:token_request) { TokenRequest.new(request) }

    describe "#key" do
      it "is the passed in key" do
        expect(token_request.key).to eq(key)
      end
    end

    describe "#secret" do
      it "is the passed in secret" do
        expect(token_request.secret).to eq(secret)
      end
    end
  end
end
