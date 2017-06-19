require 'rails_helper'

RSpec.describe "AdvocacyCampaigns", type: :request do

  describe "GET /v1/advocacy_campaigns" do
    it "provides a list of advocacy campaigns" do
      advocacy_campaigns = create_list(:advocacy_campaign, 2)

      get v1_advocacy_campaigns_path
      expect(response).to have_http_status(200)

      advocacy_campaigns.each_with_index do |advocacy_campaign, idx|
        # NOTE: if I can figure out how to pass in the base_url I can remove the #except calls below
        api_advocacy_campaign = json['data'][idx].deep_symbolize_keys.except(:links, :relationships)
        serialized_advocacy_campaign = json_resource(V1::AdvocacyCampaignResource, advocacy_campaign)[:data].deep_symbolize_keys.except(:links, :relationships)

        expect(api_advocacy_campaign).to eq(serialized_advocacy_campaign)
      end

    end
  end

  describe "POST /v1/advocacy_campaigns" do
    it "creates an advocacy campaign" do
      attributes = build(:advocacy_campaign).attributes.except('id', 'user_id', 'created_at', 'updated_at')

      targets = create_list(:target, 2)

      params = {
        data: {
          type: 'advocacy_campaigns',
          attributes: attributes,
          relationships: {
            targets: {
              data: [
                { type: 'targets', id: targets.first.id },
                { type: 'targets', id: targets.last.id }
              ]
            }
          }
        }
      }.to_json

      post v1_advocacy_campaigns_path, params: params, headers: json_api_headers_with_auth

      expect(response).to have_http_status(201)
      expect(attributes).to eq(json['data']['attributes'].except('target_list'))
      expect(json['data']['attributes']['target_list']).to_not be_empty
    end
  end

end
