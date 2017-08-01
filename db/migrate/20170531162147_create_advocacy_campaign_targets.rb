class CreateAdvocacyCampaignTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :advocacy_campaign_targets, id: :uuid do |t|
      t.references :advocacy_campaign, foreign_key: true, type: :uuid
      t.references :target, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
