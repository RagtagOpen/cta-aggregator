# This seeds file is only intended for preproduction environments
# DO NOT run this is production
# It's common for seed scripts to have a command for deleting existing records.
# There is no such command here in order to protect against someone
# accidentally running `rake db:seed` in production

FactoryGirl.create_list(:advocacy_campaign, 25, :with_targets, target_count: 1) if AdvocacyCampaign.count <= 25

FactoryGirl.create_list(:event, 25) if Target.count <= 25
