class CallToAction < ApplicationRecord
  CTA_TYPES = { onsite: 1, phone: 2 }

  has_many :call_to_action_contacts
  has_many :contacts, through: :call_to_action_contacts

  belongs_to :location, optional: true

end
