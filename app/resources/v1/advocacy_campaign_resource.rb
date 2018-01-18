module V1
  class AdvocacyCampaignResource < BaseResource
    attributes :title, :description, :browser_url, :origin_system,
      :featured_image_url, :action_type, :template, :target_list, :identifiers, :share_url

    has_one :user
    has_many :targets
    has_many :target_list

    def target_list
      @model.target_list.map(&:attributes)
    end

    filter :advocacy_campaign_type, apply: ->(records, value, _options) {
      records.where(action_type: value[0].to_s)
    }

    filter :origin_system

    filter :target_list_custom, apply: ->(records, value, _options) {
      AdvocacyCampaign.joins(:advocacy_campaign_targets).where('advocacy_campaign_targets.target_id =  ?', value[0])
    }

    before_create do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

  end
end
