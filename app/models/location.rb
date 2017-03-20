class Location < ApplicationRecord
  has_many :call_to_actions

  validates_presence_of :address_line_1, :city, :state, :zipcode
  validate :unique_location

  private

  def unique_location
		preexisting_location = self.class.where(
			address_line_1: self.address_line_1,
			address_line_2: self.address_line_2,
			city: self.city,
			state: self.state,
			zipcode: self.zipcode,
		).first

    errors.add(:location, 'already exists') if preexisting_location
  end
end
