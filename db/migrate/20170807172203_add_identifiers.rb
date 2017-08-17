class AddIdentifiers < ActiveRecord::Migration[5.0]
  def change
    add_column :advocacy_campaigns, :identifiers, :text
    add_column :events, :identifiers, :text
  end
end
