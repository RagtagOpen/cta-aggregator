class Target < ApplicationRecord

  serialize :postal_addresses, Array
  serialize :email_addresses, Array
  serialize :phone_numbers, Array

  has_many :advocacy_campaign_targets
  has_many :advocacy_campaigns, through: :advocacy_campaign_targets

  validates :organization, :given_name, :family_name, :ocdid,
    presence: true

  validate :unique_target

  def unique_target
    existing_target = Target.where(
      organization: organization,
      given_name:  given_name,
      family_name:  family_name,
      ocdid: ocdid
    ).first

    errors.add(:target, 'already exists') if existing_target
  end

end
