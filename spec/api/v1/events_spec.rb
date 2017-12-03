require 'rails_helper'

RSpec.describe "Events", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:admin) { create(:user, admin: true) }

  describe "GET /v1/events" do
    it "provides a list of events" do
      past_event = create(:event, title: 'past event', start_date: 5.days.ago)
      events = create_list(:event, 2)

      get v1_events_path
      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(2)

      events.each_with_index do |event, idx|
        # NOTE: if I can figure out how to pass in the base_url I can remove the #except calls below
        api_event = json['data'][idx].deep_symbolize_keys.except(:links, :relationships)
        serialized_event = json_resource(V1::EventResource, event)[:data].deep_symbolize_keys.except(:links, :relationships)

        expect(api_event).to eq(serialized_event)
      end

    end

    it "filters for past events" do
      past_event = create(:event, title: 'past event', start_date: 5.days.ago)
      future_event = create(:event, title: 'welcome to the future', start_date: DateTime.now + 2.days)
      serialized_past_event = json_resource(V1::EventResource, past_event)[:data].deep_symbolize_keys.except(:links, :relationships)

      get v1_events_path, params: { filter: { past: true } }

      response_data = json['data']

      expect(response_data.length).to eq(1)
      expect(response_data[0].deep_symbolize_keys.except(:links, :relationships)).to eq(serialized_past_event)
    end

    describe 'GET /v1/events/UUID' do
      it 'provides an event' do
        event = create(:event)

        get v1_event_path(id: event.id)

        expect(response).to have_http_status(200)

        api_event = json['data'].deep_symbolize_keys.except(:links, :relationships)
        serialized_event = json_resource(V1::EventResource, event)[:data].deep_symbolize_keys.except(:links, :relationships)
        expect(api_event).to eq(serialized_event)
      end
    end

    describe "GET /v1/events?filter[origin_system]" do
      it "filters events by origin_system" do
        resistance_event = create(:event, title: 'Event1', browser_url: "www.Event1.com", start_date: Time.new(2019,01,06, 11, 25, 00), origin_system: "Resistance Calendar")
        other_event = create(:event, title: 'Event2', browser_url: "www.Event2.com", start_date: Time.new(2019,01,06, 11, 25, 00), origin_system: "Other")
        serialized_resistance_event = json_resource(V1::EventResource, resistance_event)[:data].deep_symbolize_keys.except(:links, :relationships)

        get v1_events_path, params: { filter: { origin_system: "Resistance Calendar" } }
        response_data = json['data']

        expect(response_data.length).to eq(1)
        expect(response_data[0].deep_symbolize_keys.except(:links, :relationships)).to eq(serialized_resistance_event)
      end
    end

  end

  describe "POST /v1/events" do

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        post v1_events_path, params: {}, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user' do
      let(:event) { build(:event, user_id: user.id) }
      let(:attributes) { event.attributes.except('id', 'user_id', 'location_id', 'created_at', 'updated_at') }
      def params(location)
        {
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
      end

      it "creates an event for user who also created related resources" do
        location = create(:location, user_id: user.id)

        post v1_events_path, params: params(location), headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(201)

        attributes['identifiers'] << "cta-aggregator:#{json['data']['id']}"
        attributes['start_date'] = attributes['start_date'].strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        attributes['end_date'] = attributes['end_date'].strftime('%Y-%m-%dT%H:%M:%S.%LZ')

        expect(attributes).to eq(json['data']['attributes'])
      end

      it "creates an event for user who did not create related resources" do
        location = create(:location)

        post v1_events_path, params: params(location), headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(201)

        attributes['identifiers'] << "cta-aggregator:#{json['data']['id']}"
        attributes['start_date'] = attributes['start_date'].strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        attributes['end_date'] = attributes['end_date'].strftime('%Y-%m-%dT%H:%M:%S.%LZ')

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

        post v1_events_path, params: params, headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(302)
        expect(response.headers['Location']).to match(existing_id)
      end
    end
  end

  describe "PUT /v1/events/UUID" do
    let(:event) { create(:event, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": event.id,
          "type": "events",
          "attributes": {
            "title": "foobar"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        put v1_event_path(event.id), params: params, headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        put v1_event_path(event.id), params: params, headers: json_api_headers_with_auth(another_user.id)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the event' do
        put v1_event_path(event.id), params: params, headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(200)
      end
    end

    context 'with authenticated admin' do
      it 'updates the event' do
        put v1_event_path(event.id), params: params, headers: json_api_headers_with_auth(admin.id)

        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /v1/events/UUID" do
    let(:event) { create(:event, user_id: user.id) }
    let(:params) do
      {
        "data": {
          "id": event.id,
          "type": "events",
          "attributes": {
            "title": "foobar"
          }
        }
      }.to_json
    end

    context 'with no authentication' do
      it 'returns as unauthenticated' do
        delete v1_event_path(event.id), headers: {}

        expect(response).to have_http_status(401)
      end
    end

    context 'with authenticated user who did not create the record originally' do
      it 'returns as unauthorized' do
        delete v1_event_path(event.id), headers: json_api_headers_with_auth(another_user.id)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated user who created the record originally' do
      it 'updates the event' do
        delete v1_event_path(event.id), headers: json_api_headers_with_auth(user.id)

        expect(response).to have_http_status(403)
      end
    end

    context 'with authenticated admin' do
      it 'updates the event' do
        delete v1_event_path(event.id), headers: json_api_headers_with_auth(admin.id)

        expect(response).to have_http_status(204)
      end
    end
  end
end
