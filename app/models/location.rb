class Location < ApplicationRecord
  has_many :call_to_actions

  validates_presence_of :address
  validate :unique_location, :sufficient_location_data_present
  validates_length_of :state, is: 2

  private

  def unique_location
    preexisting_location = self.class.where(
      address: self.address,
      city: self.city,
      state: self.state,
      zipcode: self.zipcode,
    ).first

    errors.add(:location, 'already exists') if preexisting_location
  end

  def sufficient_location_data_present
    unless (self.city && self.state) || self.zipcode
      errors.add(:location, 'requires city and state or zipcode')
    end
  end

end
