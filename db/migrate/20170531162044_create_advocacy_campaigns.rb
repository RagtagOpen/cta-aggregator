class CreateAdvocacyCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :advocacy_campaigns, id: :uuid do |t|
      t.string :title
      t.text :description
      t.string :browser_url
      t.string :origin_system
      t.string :featured_image_url
      t.string :action_type
      t.text :template
      t.references :user, type: :uuid

      t.timestamps
    end
  end
end
