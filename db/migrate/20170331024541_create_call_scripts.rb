class CreateCallScripts < ActiveRecord::Migration[5.0]
  def change
    create_table :call_scripts, id: :uuid do |t|
      t.text :text
      t.string :checksum, limit: 64

      t.timestamps
    end
    add_index :call_scripts, :checksum
    # add_column :events, :call_script_id, :uuid
  end
end
