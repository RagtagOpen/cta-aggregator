class AlterEventsAddShareCol < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :share_url, :string
  end
end
