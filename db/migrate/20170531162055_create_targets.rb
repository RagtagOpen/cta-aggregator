class CreateTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :targets, id: :uuid do |t|
      t.string :organization
      t.string :given_name
      t.string :family_name
      t.string :ocdid
      t.text :postal_addresses
      t.text :email_addresses
      t.text :phone_numbers

      t.timestamps
    end
  end
end
