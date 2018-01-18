require 'rails_helper'

RSpec.describe "AdvocacyCampaigns", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:admin) { create(:user, admin: true) }

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

    describe "GET /v1/advocacy_campaigns?filter[origin_system]" do
      it "filters advocacy campaigns by origin_system" do
        fiveCalls_campaign = create(:advocacy_campaign, title: "Campaign1", description: "Description1" , origin_system: "5calls", action_type: "phone")
        other_advocacy_campaign = create(:advocacy_campaign, title: "Campaign2", description: "Description2" , origin_system: "Other", action_type: "in-person")
        serialized_fiveCalls_campaign = json_resource(V1::AdvocacyCampaignResource, fiveCalls_campaign)[:data].deep_symbolize_keys.except(:links, :relationships)

        get v1_advocacy_campaigns_path, params: { filter: { origin_system: "5calls" } }
        response_data = json['data']

        expect(response_data.length).to eq(1)
        expect(response_data[0].deep_symbolize_keys.except(:links, :relationships)).to eq(serialized_fiveCalls_campaign)
      end
    end

    describe "GET /v1/advocacy_campaigns?filter[target_list]" do
      it "filters advocacy campaigns by target id" do
        abc_target = create(:target, organization: "Abc")
        def_target = create(:target, organization: "Def")

        fiveCalls_campaign = create(:advocacy_campaign, title: "Campaign1", description: "Description1" , origin_system: "5calls", action_type: "phone", target_list: [abc_target])
        other_advocacy_campaign = create(:advocacy_campaign, title: "Campaign2", description: "Description2" , origin_system: "Other", action_type: "phone", target_list: [def_target])
        no_target_advocacy_campaign = create(:advocacy_campaign, title: "Campaign3", description: "Description3" , origin_system: "Other", action_type: "phone")

        serialized_fiveCalls_campaign = json_resource(V1::AdvocacyCampaignResource, fiveCalls_campaign)[:data].deep_symbolize_keys.except(:links, :relationships, :created_at, :updated_at)
        get v1_advocacy_campaigns_path, params: { filter: { target_list_custom: "#{abc_target.id}" } }
        response_data = json['data']

        expect(response_data.length).to eq(1)
        expect(response_data[0].deep_symbolize_keys.except(:links, :relationships, :created_at, :updated_at)).to eq(serialized_fiveCalls_campaign) 
        
        #Issue: Test returns correct object BUT expects timestamp objects to be date/time format and the app is returning them as string
        #Next Step: Remove timestamp data from information returned on a Target query (likely on the model)
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
      let(:advocacy_campaign) { build(:advocacy_campaign, user_id: user.id) }
      let(:attributes) { advocacy_campaign.attributes.except('id', 'user_id', 'created_at', 'updated_at') }

      def params(targets)
        {
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
      end

      it "creates an advocacy campaign for user who also created related resources" do

        targets = create_list(:target, 2, user_id: user.id)

        post v1_advocacy_campaigns_path, params: params(targets), headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(201)
        attributes['identifiers'] << "cta-aggregator:#{json['data']['id']}"

        expect(attributes).to eq(json['data']['attributes'].except('target_list'))
        expect(json['data']['attributes']['target_list']).to_not be_empty
      end

      it "creates an advocacy campaign for user who did not create related resources" do
        targets = create_list(:target, 2)

        post v1_advocacy_campaigns_path, params: params(targets), headers: json_api_headers_with_auth(user.id)

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

        post v1_advocacy_campaigns_path, params: params, headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(302)
        expect(response.headers['Location']).to match(existing_id)
      end
    end
  end

  describe "PUT /v1/advocacy_campaigns/UUID" do
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
        put v1_advocacy_campaign_path(advocacy_campaign.id), params: params, headers: json_api_headers_with_auth(another_user.id)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the advocacy campaign' do
        put v1_advocacy_campaign_path(advocacy_campaign.id), params: params, headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(200)
      end
    end

    context 'with authenticated admin' do
      it 'updates the advocacy campaign' do
        put v1_advocacy_campaign_path(advocacy_campaign.id), params: params, headers: json_api_headers_with_auth(admin.id)

        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /v1/advocacy_campaigns/UUID" do
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
        delete v1_advocacy_campaign_path(advocacy_campaign.id), headers: json_api_headers_with_auth(another_user.id)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the advocacy campaign' do
        delete v1_advocacy_campaign_path(advocacy_campaign.id), headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated admin' do
      it 'updates the advocacy campaign' do
        delete v1_advocacy_campaign_path(advocacy_campaign.id), headers: json_api_headers_with_auth(admin.id)

        expect(response).to have_http_status(204)
      end
    end
  end
end
