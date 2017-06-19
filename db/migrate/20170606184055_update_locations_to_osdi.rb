class UpdateLocationsToOsdi < ActiveRecord::Migration[5.0]
  def up
    change_table :locations do |t|
      t.remove :notes
      t.change :address, :text
      t.rename :city, :locality
      t.rename :state, :region
      t.rename :zipcode, :postal_code
      t.rename :address, :address_lines
      t.string :venue
    end
  end

  def down
    change_table :locations do |t|
      t.remove :venue
      t.text :notes
      t.rename :locality, :city
      t.rename :region, :state
      t.rename :postal_code, :zipcode
      t.rename :address_lines, :address
      t.change :address, :string
    end
  end
end
