class AddUserToOtherModels < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :user_id, :uuid
    add_column :locations, :user_id, :uuid
    add_column :targets, :user_id, :uuid
  end
end
