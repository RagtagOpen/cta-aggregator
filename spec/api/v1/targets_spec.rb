require 'rails_helper'

RSpec.describe "Targets", type: :request do

  describe "GET /v1/targets" do
    it "provides a list of targets" do
      targets = [].tap do |list|
        list << create(:target)
        list << create(:target)
      end

      get v1_targets_path
      expect(response).to have_http_status(200)

      targets.each_with_index do |target, idx|
        # NOTE: if I can figure out how to pass in the base_url I can remove the #except calls below
        api_target = json['data'][idx].deep_symbolize_keys.except(:links, :relationships)
        serialized_target = json_resource(V1::TargetResource, target)[:data].deep_symbolize_keys.except(:links, :relationships)

        expect(api_target).to eq(serialized_target)
      end

    end
  end

  describe "POST /v1/targets" do
    it "creates a target" do
      attributes = build(:target).attributes.except('id', 'user_id', 'created_at', 'updated_at')

      params = {
        data: {
          type: 'targets',
          attributes: attributes
        }
      }.to_json

      post v1_targets_path, params: params, headers: json_api_headers_with_auth

      expect(response).to have_http_status(201)
      expect(attributes.deep_stringify_keys).to eq(json['data']['attributes'])
    end

    it "redirects on duplicate create" do
      attributes = create(:target).attributes.except('user_id', 'created_at', 'updated_at')
      existing_id = attributes.delete('id')

      params = {
        data: {
          type: 'targets',
          attributes: attributes
        }
      }.to_json

      post v1_targets_path, params: params, headers: json_api_headers_with_auth

      expect(response).to have_http_status(302)
      expect(response.headers['Location']).to match(existing_id)
    end

  end

end
