module V1
  class EventResource < JSONAPI::Resource
    attributes :title, :description, :browser_url, :origin_system,
      :featured_image_url, :start_date, :end_date, :free

    has_one :location
  end
end
