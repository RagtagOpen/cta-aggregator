module V1
  class EventResource < JSONAPI::Resource
    attributes :title, :description, :free, :start_time, :end_time, :event_type, :website

    relationship :location, to: :one
    relationship :contact, to: :one
    relationship :call_script, to: :one

    filter :upcoming, apply: -> (records, value, _options) {
      records.upcoming if value[0] == "true"
    }

    filter :event_type, apply: ->(records, value, _options) {
      records.where(action_type: Event::CTA_TYPES[value[0].to_sym])
    }

    def start_time
      @model.start_at.to_i
    end

    def start_time=(start_at)
      @model.start_at = DateTime.strptime(start_at, "%s")
    end

    def end_time=(end_at)
      @model.end_at = DateTime.strptime(end_at, "%s")
    end

    def end_time
      @model.end_at.to_i
    end
  end
end
