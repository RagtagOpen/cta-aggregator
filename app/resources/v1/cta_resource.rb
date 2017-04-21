module V1
  class CTAResource < JSONAPI::Resource
    attributes :title, :description, :free, :start_time, :end_time, :cta_type, :website

    relationship :location, to: :one
    relationship :contact, to: :one
    relationship :call_script, to: :one
    relationship :user, to: :one, always_include_linkage_data: true

    filter :upcoming, apply: -> (records, value, _options) {
      records.upcoming if value[0] == "true"
    }

    filter :cta_type, apply: ->(records, value, _options) {
      records.where(action_type: CTA::CTA_TYPES[value[0].to_sym])
    }

    before_save do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

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
