class Location < ApplicationRecord
  serialize :address_lines

  belongs_to :user, optional: true

  validate :unique_location
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

end
