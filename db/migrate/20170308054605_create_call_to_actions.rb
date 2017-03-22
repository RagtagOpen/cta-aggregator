class CreateCallToActions < ActiveRecord::Migration[5.0]
  def change
    create_table :call_to_actions, id: :uuid do |t|
      t.string :title
      t.text :description
      t.boolean :free
      t.string :website
      t.datetime :start
      t.datetime :end
      t.string :user_uuid
      t.integer :action_type

      t.timestamps
    end
  end
end
