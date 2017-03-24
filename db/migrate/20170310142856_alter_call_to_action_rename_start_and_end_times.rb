class AlterCallToActionRenameStartAndEndTimes < ActiveRecord::Migration[5.0]
  def change
    rename_column :call_to_actions, :start, :start_at
    rename_column :call_to_actions, :end, :end_at
  end
end
