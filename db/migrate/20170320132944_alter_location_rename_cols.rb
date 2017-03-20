class AlterLocationRenameCols < ActiveRecord::Migration[5.0]
  def change
    rename_column :locations, :postal_code, :zipcode
    rename_column :locations, :address_line1, :address_line_1
    rename_column :locations, :address_line2, :address_line_2
  end
end
