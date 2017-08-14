class AlterTargetsAddTitle < ActiveRecord::Migration[5.0]
  def change
    add_column :targets, :title, :string
  end
end
