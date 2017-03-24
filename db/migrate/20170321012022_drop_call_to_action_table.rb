class DropCallToActionTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :call_to_actions
  end
end
