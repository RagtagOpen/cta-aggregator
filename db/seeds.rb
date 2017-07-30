# This seeds file is only intended for preproduction environments
# DO NOT run this is production
# It's common for seed scripts to have a command for deleting existing records.
# There is no such command here in order to protect against someone
# accidentally running `rake db:seed` in production

# FactoryGirl.create_list(:advocacy_campaign, 25, :with_targets, target_count: 1) if AdvocacyCampaign.count <= 25

# FactoryGirl.create_list(:event, 25) if Target.count <= 25

# Import 5calls data
path = Rails.root.join('db','seeds','5calls_advocacy_campaigns.yaml')

File.open(path) do |file|
  YAML.load_documents(file) do |doc|
    doc.each do |cta|
      targets = [].tap do |list|
        list << cta[:target_list].map! do |t|
          Target.where(
            organization: t[:organization],
            given_name: t[:given_name],
            family_name: t[:family_name],
            ocdid: t[:ocdid]
          ).first_or_create!
        end
      end

      campaign = AdvocacyCampaign.where(
        title: cta[:title],
        browser_url: cta[:browser_url]
      ).first_or_create!(
        origin_system: cta[:origin_system],
        description: cta[:description],
        action_type: cta[:action_type],
        template: cta[:template],
        target_list: targets.flatten
      )
    end
  end
end

# Import Emily's List data
path = Rails.root.join('db','seeds','emilys_list_events.yaml')

File.open(path) do |file|
  YAML.load_documents(file) do |doc|
    doc.each{ |e|
      e.deep_symbolize_keys!

      location = Location.where(
        address_lines: e[:location][:address_lines],
        locality: e[:location][:locality],
        region: e[:location][:region].to_s.gsub('.', ''),
        postal_code: e[:location][:postal_code]
      ).first_or_create!

      event = Event.where(
        start_date: e[:start_date],
        title: e[:title],
        origin_system: e[:origin_system],
        browser_url: e[:browser_url],
        free: !! e[:free]
      ).first_or_create!(
        location: location
      )
    }
  end
end
