# This seeds file is only intended for preproduction environments
# DO NOT run this is production
# It's common for seed scripts to have a command for deleting existing records.
# There is no such command here in order to protect against someone
# accidentally running `rake db:seed` in production

# FactoryGirl.create_list(:advocacy_campaign, 25, :with_targets, target_count: 1) if AdvocacyCampaign.count <= 25

# FactoryGirl.create_list(:event, 25) if Target.count <= 25

path = Rails.root.join('db','seeds','5calls_advocacy_campaigns.yaml')

File.open(path) do |file|
  YAML.load_documents(file) do |doc|
    doc.each{ |cta|
      # skip if there's nobody to call (this is the location-indepent data)
      next if cta[:target_list].empty?
      cta[:target_list].map!{ |t|
        puts "target phone numbers: #{t[:phone_numbers]}"
        Target.find_or_create_by!(t)
      }
      puts "find or create cta by #{cta}"
      campaign = AdvocacyCampaign.find_or_create_by(:origin_system => cta[:origin_system])
      campaign.update!(cta)
    }
  end
end
