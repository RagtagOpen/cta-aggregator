class AdvocacyCampaignTarget < ApplicationRecord
  belongs_to :advocacy_campaign
  belongs_to :target
end
