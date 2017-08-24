class Target < ApplicationRecord

  serialize :postal_addresses, Array
  serialize :email_addresses, Array
  serialize :phone_numbers, Array

  belongs_to :user, optional: true

  has_many :advocacy_campaign_targets, dependent: :destroy
  has_many :advocacy_campaigns, through: :advocacy_campaign_targets

  validate :organization_or_name

  validate :unique_target, on: [:create, :update]

  private

    def organization_or_name
      unless organization || (given_name && family_name)
        errors.add(:base, 'organization or combo of given and family name required')
      end

    end

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
