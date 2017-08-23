require 'rails_helper'

RSpec.describe "Locations", type: :request do

  describe "GET /v1/locations" do
    it "provides a list of locations" do
      locations = create_list(:location, 2)

      get v1_locations_path
      expect(response).to have_http_status(200)

      locations.each_with_index do |location, idx|
        # NOTE: if I can figure out how to pass in the base_url I can remove the #except calls below
        api_location = json['data'][idx].deep_symbolize_keys.except(:links, :relationships)
        serialized_location = json_resource(V1::LocationResource, location)[:data].deep_symbolize_keys.except(:links, :relationships)

        expect(api_location).to eq(serialized_location)
      end
    end

    describe 'GET /v1/locations/UUID' do
      it 'provides a location' do
        location = create(:location)

        get v1_locations_path(id: location.id)

        expect(response).to have_http_status(200)

        api_location = JSON.parse(response.body)['data'][0].deep_symbolize_keys.except(:links, :relationships)
        serialized_location = json_resource(V1::LocationResource, location)[:data].deep_symbolize_keys.except(:links, :relationships)
        expect(api_location).to eq(serialized_location)
      end
    end
  end

  describe "POST /v1/locations" do
    context 'with no authentication' do
      it 'returns as authenticated' do
        post v1_locations_path, params: {}, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authentication' do
      it "creates a location" do
        attributes = build(:location).attributes.except('id', 'user_id', 'created_at', 'updated_at')

        params = {
          data: {
            type: 'locations',
            attributes: attributes
          }
        }.to_json

        post v1_locations_path, params: params, headers: json_api_headers_with_auth

        expect(response).to have_http_status(201)
        expect(attributes.deep_stringify_keys).to eq(json['data']['attributes'])
      end

      it "redirects on duplicate create" do
        attributes = create(:location).attributes.except('created_at', 'updated_at')
        existing_id = attributes.delete('id')

        params = {
          data: {
            type: 'locations',
            attributes: attributes
          }
        }.to_json

        post v1_locations_path, params: params, headers: json_api_headers_with_auth

        expect(response).to have_http_status(302)
        expect(response.headers['Location']).to match(existing_id)
      end
    end
  end

  describe "PUT /v1/locations/UUID" do
    let(:user) { create(:user) }
    let(:location) { create(:location, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": location.id,
          "type": "locations",
          "attributes": {
            "locality": "San Bernadino"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        put v1_location_path(location.id), params: params, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        another_user = create(:user)
        put v1_location_path(location.id), params: params, headers: json_api_headers_with_auth(another_user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the location' do
        put v1_location_path(location.id), params: params, headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(200)
      end
    end

    context 'with authenticated admin' do
      it 'updates the location' do
        put v1_location_path(location.id), params: params, headers: json_api_headers_with_admin_auth

        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /v1/locations/UUID" do
    let(:user) { create(:user) }
    let(:location) { create(:location, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": location.id,
          "type": "locations",
          "attributes": {
            "title": "foobar"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        delete v1_location_path(location.id), headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        another_user = create(:user)
        delete v1_location_path(location.id), headers: json_api_headers_with_auth(another_user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the location' do
        delete v1_location_path(location.id), headers: json_api_headers_with_auth(user)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated admin' do
      it 'updates the location' do
        delete v1_location_path(location.id), headers: json_api_headers_with_admin_auth

        expect(response).to have_http_status(204)
      end
    end
  end
end
