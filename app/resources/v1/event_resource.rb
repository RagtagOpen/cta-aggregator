module V1
  class EventResource < JSONAPI::Resource
    attributes :title, :description, :browser_url, :origin_system,
      :featured_image_url, :start_date, :end_date, :free

    has_one :location
    has_one :user

    before_create do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

    filter :upcoming, apply: -> (records, value, _options) {
      records.upcoming if value[0] == "true"
    }

  end
end
