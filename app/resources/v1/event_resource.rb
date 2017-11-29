module V1
  class EventResource < BaseResource
    attributes :title, :description, :browser_url, :origin_system,
      :featured_image_url, :start_date, :end_date, :free, :identifiers, :share_url

    has_one :location
    has_one :user

    before_create do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

    filter :upcoming, default: 'true', apply: -> (records, value, _options) {
      records.upcoming if value[0] == "true"
    }

    filter :past, apply: -> (records, value, _options) {
      records.unscope(:where).past if value[0] == "true"
    }

    filter :origin_system # This enables: http://example.com/events?filter[origin_system]=5calls
    # issue: events with and without filters do not appear when hosted locally (no issue for deployed version)

  end
end
