class AdvocacyCampaign < ApplicationRecord

  belongs_to :user, optional: true

  has_many :advocacy_campaign_targets, dependent: :destroy
  has_many :target_list, through: :advocacy_campaign_targets, source: :target

  validate :validate_uniqueness, on: [:create, :update]

  validates :title, :description, :origin_system, :action_type,
    presence: true

  def target_ids=(ids)
    self.target_list_ids = ids
  end

  private

    def validate_uniqueness
      return if changes.empty?

      preexisting_advocacy_campaign = AdvocacyCampaign.where(
        title: title,
        description: description,
        action_type: action_type,
        browser_url: browser_url
      ).first

      errors.add(:advocacy_campaign, 'already exists') if preexisting_advocacy_campaign
    end

end
