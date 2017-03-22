class CreateCallToActionContacts < ActiveRecord::Migration[5.0]
  def change
    create_join_table(:call_to_actions, :contacts, column_options: {type: :uuid})
  end
end
