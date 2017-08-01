class AlterLocationsReviseLocationFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :address_line_2
    rename_column :locations, :address_line_1, :address
  end
end
