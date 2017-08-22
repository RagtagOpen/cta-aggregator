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

end
