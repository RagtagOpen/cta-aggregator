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

    describe 'GET /v1/targets/UUID' do
      it 'provides a target' do
        target = create(:target)

        get v1_targets_path(id: target.id)

        expect(response).to have_http_status(200)

        api_target = JSON.parse(response.body)['data'][0].deep_symbolize_keys.except(:links, :relationships)
        serialized_target = json_resource(V1::TargetResource, target)[:data].deep_symbolize_keys.except(:links, :relationships)
        expect(api_target).to eq(serialized_target)
      end
    end
  end

  describe "POST /v1/targets" do
    context 'with no authentication' do
      it 'returns as unauthenticated' do
        post v1_targets_path, params: {}, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user' do
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


  describe "PUT /v1/targets/UUID" do
    let(:user) { create(:user) }
    let(:target) { create(:target, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": target.id,
          "type": "targets",
          "attributes": {
            "given_name": "foobar"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        put v1_target_path(target.id), params: params, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        another_user = create(:user)
        put v1_target_path(target.id), params: params, headers: json_api_headers_with_auth(another_user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the advocacy campaign' do
        put v1_target_path(target.id), params: params, headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(200)
      end
    end

    context 'with authenticated admin' do
      it 'updates the advocacy campaign' do
        put v1_target_path(target.id), params: params, headers: json_api_headers_with_admin_auth

        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /v1/targets/UUID" do
    let(:user) { create(:user) }
    let(:target) { create(:target, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": target.id,
          "type": "targets",
          "attributes": {
            "title": "foobar"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        delete v1_target_path(target.id), headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        another_user = create(:user)
        delete v1_target_path(target.id), headers: json_api_headers_with_auth(another_user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the advocacy campaign' do
        delete v1_target_path(target.id), headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated admin' do
      it 'updates the advocacy campaign' do
        delete v1_target_path(target.id), headers: json_api_headers_with_admin_auth

        expect(response).to have_http_status(204)
      end
    end
  end
end
