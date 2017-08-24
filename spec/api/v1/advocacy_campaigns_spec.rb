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

    describe 'GET /v1/advocacy_campaign/UUID' do
      it 'provides an advocacy campaign' do
        advocacy_campaign = create(:advocacy_campaign)

        get v1_advocacy_campaign_path(id: advocacy_campaign.id)
        expect(response).to have_http_status(200)

        api_advocacy_campaign = JSON.parse(response.body)['data'].deep_symbolize_keys.except(:links, :relationships)
        serialized_advocacy_campaign = json_resource(V1::AdvocacyCampaignResource, advocacy_campaign)[:data].deep_symbolize_keys.except(:links, :relationships)
        expect(api_advocacy_campaign).to eq(serialized_advocacy_campaign)
      end
    end
  end

  describe "POST /v1/advocacy_campaigns" do
    context 'with no authentication' do
      it 'returns as unauthorized' do
        post v1_advocacy_campaigns_path, params: {}, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user' do
      let(:user) { create(:user) }

      it "creates an advocacy campaign" do
        advocacy_campaign = build(:advocacy_campaign, user_id: user.id)

        attributes = advocacy_campaign.attributes.except('id', 'user_id', 'created_at', 'updated_at')

        targets = create_list(:target, 2, user_id: user.id)

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

        post v1_advocacy_campaigns_path, params: params, headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(201)
        attributes['identifiers'] << "cta-aggregator:#{json['data']['id']}"

        expect(attributes).to eq(json['data']['attributes'].except('target_list'))
        expect(json['data']['attributes']['target_list']).to_not be_empty
      end

      it "redirects on duplicate create" do
        attributes = create(:advocacy_campaign).attributes.except('created_at', 'updated_at')
        existing_id = attributes.delete('id')

        params = {
          data: {
            type: 'advocacy_campaigns',
            attributes: attributes,
          }
        }.to_json

        post v1_advocacy_campaigns_path, params: params, headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(302)
        expect(response.headers['Location']).to match(existing_id)
      end
    end
  end

  describe "PUT /v1/advocacy_campaigns/UUID" do
    let(:user) { create(:user) }
    let(:advocacy_campaign) { create(:advocacy_campaign, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": advocacy_campaign.id,
          "type": "advocacy_campaigns",
          "attributes": {
            "title": "foobar"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        put v1_advocacy_campaign_path(advocacy_campaign.id), params: params, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        another_user = create(:user)
        put v1_advocacy_campaign_path(advocacy_campaign.id), params: params, headers: json_api_headers_with_auth(another_user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the advocacy campaign' do
        put v1_advocacy_campaign_path(advocacy_campaign.id), params: params, headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(200)
      end
    end

    context 'with authenticated admin' do
      it 'updates the advocacy campaign' do
        put v1_advocacy_campaign_path(advocacy_campaign.id), params: params, headers: json_api_headers_with_admin_auth

        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /v1/advocacy_campaigns/UUID" do
    let(:user) { create(:user) }
    let(:advocacy_campaign) { create(:advocacy_campaign, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": advocacy_campaign.id,
          "type": "advocacy_campaigns",
          "attributes": {
            "title": "foobar"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        delete v1_advocacy_campaign_path(advocacy_campaign.id), headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        another_user = create(:user)
        delete v1_advocacy_campaign_path(advocacy_campaign.id), headers: json_api_headers_with_auth(another_user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the advocacy campaign' do
        delete v1_advocacy_campaign_path(advocacy_campaign.id), headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated admin' do
      it 'updates the advocacy campaign' do
        delete v1_advocacy_campaign_path(advocacy_campaign.id), headers: json_api_headers_with_admin_auth

        expect(response).to have_http_status(204)
      end
    end
  end
end
