class AlterLocationsLimitStateLength < ActiveRecord::Migration[5.0]
  def change
    change_column :locations, :state, :string, limit: 2
  end
end
