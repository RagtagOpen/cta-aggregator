class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events, id: :uuid do |t|
      t.string :title
      t.text :description
      t.string :browser_url
      t.string :origin_system
      t.string :featured_image_url
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :free
      t.uuid :location_id

      t.timestamps
    end
  end
end
