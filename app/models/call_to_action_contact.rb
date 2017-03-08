class CallToActionContact < ApplicationRecord
  self.table_name = "call_to_actions_contacts"

  belongs_to :call_to_action
  belongs_to :contact
end
