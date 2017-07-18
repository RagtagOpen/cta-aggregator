class Target < ApplicationRecord

  serialize :postal_addresses, Array
  serialize :email_addresses, Array
  serialize :phone_numbers, Array

  belongs_to :user, optional: true

  has_many :advocacy_campaign_targets
  has_many :advocacy_campaigns, through: :advocacy_campaign_targets

  validates :organization,
    presence: true

  validate :unique_target, on: [:create, :update]

  private

    def unique_target
      return if changes.empty?

      existing_target = Target.where(
        organization: organization,
        given_name:  given_name,
        family_name:  family_name
      ).first

      errors.add(:target, 'already exists') if existing_target
    end

end
