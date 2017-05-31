class RemoveUnusedModels < ActiveRecord::Migration[5.0]
  def up
    drop_table :call_scripts
    drop_table :contacts
    drop_table :ctas
  end
end
