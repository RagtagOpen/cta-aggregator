require 'rails_helper'

RSpec.describe "Events", type: :request do

  describe "GET /v1/events" do
    it "provides a list of events" do
      events = create_list(:event, 2)

      get v1_events_path
      expect(response).to have_http_status(200)

      events.each_with_index do |event, idx|
        # NOTE: if I can figure out how to pass in the base_url I can remove the #except calls below
        api_event = json['data'][idx].deep_symbolize_keys.except(:links, :relationships)
        serialized_event = json_resource(V1::EventResource, event)[:data].deep_symbolize_keys.except(:links, :relationships)

        expect(api_event).to eq(serialized_event)
      end

    end

    it "filters for future events" do
      past_event = create(:event, title: 'past event', start_date: 5.days.ago)
      future_event = create(:event, title: 'welcome to the future', start_date: DateTime.now + 2.days)
      serialized_future_event = json_resource(V1::EventResource, future_event)[:data].deep_symbolize_keys.except(:links, :relationships)

      get v1_events_path, params: { filter: { upcoming: true } }

      response_data = JSON.parse(response.body)['data']

      expect(response_data.length).to eq(1)
      expect(response_data[0].deep_symbolize_keys.except(:links, :relationships)).to eq(serialized_future_event)
    end
  end

  describe "POST /v1/events" do

    context 'with no authentication' do
      it 'returns as unauthorized' do
        post v1_events_path, params: {}, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authentication' do

      it "creates an event" do
        event = build(:event)
        attributes = event.attributes.except('id', 'user_id', 'location_id', 'created_at', 'updated_at')

        location = create(:location)

        params = {
          data: {
            type: 'events',
            attributes: attributes,
            relationships: {
              location: {
                data: { type: 'locations', id: location.id }
              }
            }
          }
        }.to_json

        post v1_events_path, params: params, headers: json_api_headers_with_auth

        attributes['identifiers'] << "cta-aggregator:#{json['data']['id']}"

        attributes['start_date'] = attributes['start_date'].strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        attributes['end_date'] = attributes['end_date'].strftime('%Y-%m-%dT%H:%M:%S.%LZ')

        expect(response).to have_http_status(201)
        expect(attributes).to eq(json['data']['attributes'])

      end

      it "redirects on duplicate create" do
        attributes = create(:event).attributes.except('created_at', 'updated_at')
        existing_id = attributes.delete('id')
        location_id = attributes.delete('location_id')

        params = {
          data: {
            type: 'events',
            attributes: attributes,
            relationships: {
              location: {
                data: { type: 'locations', id: location_id }
              }
            }
          }
        }.to_json

        post v1_events_path, params: params, headers: json_api_headers_with_auth

        expect(response).to have_http_status(302)
        expect(response.headers['Location']).to match(existing_id)
      end
    end
  end

end
