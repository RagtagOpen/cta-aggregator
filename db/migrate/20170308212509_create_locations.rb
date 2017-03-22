class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :call_to_actions, :location_id, :uuid

    create_table :locations, id: :uuid do |t|
      t.string :address_line1, limit: 1000
      t.string :address_line2, limit: 1000
      t.string :city
      t.string :state
      t.string :postal_code
      t.text :notes

      t.timestamps
    end
  end
end
