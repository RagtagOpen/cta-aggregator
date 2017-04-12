class CreateCtas < ActiveRecord::Migration[5.0]
  def change
    create_table :ctas, id: :uuid do |t|
      t.string :title
      t.text :description
      t.string :website
      t.boolean :free, default: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :action_type
      t.uuid    :location_id
      t.uuid    :contact_id
      t.uuid    :call_script_id

      t.timestamps
    end
  end
end
