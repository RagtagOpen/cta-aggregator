class Contact < ApplicationRecord
  has_many :call_to_action_contacts
  has_many :call_to_actions, through: :call_to_action_contacts

  validates_presence_of :name
  validates :email, uniqueness: true, format: /.+@.+\..+/i
  validate :presence_of_phone_or_email

  private

  def presence_of_phone_or_email
    comm_methods_present = self.email || self.phone
    errors.add(:phone_or_email, 'must be pressent') unless comm_methods_present
  end

end
