class Location < ApplicationRecord
  has_many :call_to_actions

  validates_presence_of :address_line1, :city, :state, :postal_code
  validate :unique_location

  private

  def unique_location
		preexisting_location = self.class.where(
			address_line1: self.address_line1,
			address_line2: self.address_line2,
			city: self.city,
			state: self.state,
			postal_code: self.postal_code,
		).first

    errors.add(:id, 'already exists') if preexisting_location
    # is there a better attribute to add this error to?
  end
end
