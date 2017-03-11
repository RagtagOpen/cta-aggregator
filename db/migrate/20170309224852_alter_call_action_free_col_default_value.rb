class AlterCallActionFreeColDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column :call_to_actions, :free, :boolean, default: true
  end
end
