class Location < ApplicationRecord
  serialize :address_lines

  belongs_to :user, optional: true

  validates_presence_of :address_lines
  validate :unique_location, :sufficient_location_data_present
  validates_length_of :region, is: 2, if: -> { self.region }

  private

  def unique_location
    preexisting_location = Location.where(
      address_lines: address_lines,
      locality: locality,
      region: region,
      postal_code: postal_code,
    ).first

    errors.add(:location, 'already exists') if preexisting_location
  end

  def sufficient_location_data_present
    unless (locality && region) || postal_code
      errors.add(:location, 'requires locality and region or postal_code')
    end
  end

end
