class AlterAdvocacyCamaignAddShareUrlCol < ActiveRecord::Migration[5.0]
  def change
    add_column :advocacy_campaigns, :share_url, :string
  end
end
