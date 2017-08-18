module V1
  class AdvocacyCampaignResource < JSONAPI::Resource
    attributes :title, :description, :browser_url, :origin_system,
      :featured_image_url, :action_type, :template, :identifiers

    has_one :user
    has_many :targets
    has_many :target_list

    def target_list
      @model.target_list.map(&:attributes)
    end

    filter :advocacy_campaign_type, apply: ->(records, value, _options) {
      records.where(action_type: value[0].to_s)
    }

    before_create do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

  end
end
