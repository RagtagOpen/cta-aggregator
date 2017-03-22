class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
