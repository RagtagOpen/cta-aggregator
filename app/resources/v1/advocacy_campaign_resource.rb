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

    filter :target_list, apply: ->(records, value, _options) {
      target_campaigns = []

      records.each do |campaign|
        campaign.target_list.each do |target_object|
          target_campaigns << campaign if target_object.id == value[0]
        end
      end

      target_campaigns.uniq
    }

    #SQL query for finding targets by id
    # SELECT  "targets".* FROM "targets" WHERE "targets"."id" = '98531f36-96b3-4083-ae6d-2fc07a399e71'

    before_create do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

  end
end
