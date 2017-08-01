class AlterCTAAddIndices < ActiveRecord::Migration[5.0]
  def change
    add_index :ctas, :start_at
    add_index :ctas, [:start_at, :action_type, :website, :title], unique: true
  end
end
