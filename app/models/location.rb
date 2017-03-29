class Location < ApplicationRecord
  has_many :call_to_actions

  validates_presence_of :address, :city, :state, :zipcode
  validate :unique_location

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
end
