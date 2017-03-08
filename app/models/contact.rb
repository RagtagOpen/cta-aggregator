class Contact < ApplicationRecord
  has_many :call_to_action_contacts
  has_many :call_to_actions, through: :call_to_action_contacts
end
