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
          ).first_or_create!(
            postal_addresses: t[:postal_addresses],
            email_addresses: t[:email_addresses],
            phone_numbers: [t[:phone_numbers]]
          )
        end
      end

      campaign = AdvocacyCampaign.where(
        title: cta[:title],
        browser_url: cta[:browser_url]
      ).first_or_create!(
        identifiers: cta[:identifiers],
        origin_system: cta[:origin_system],
        description: cta[:description],
        action_type: cta[:action_type],
        template: cta[:template],
        target_list: targets.flatten
      )
    end
  end
end

def import_events(filename)
  path = Rails.root.join('db','seeds',filename)

  File.open(path) do |file|
    YAML.load_documents(file) do |doc|
      doc.each{ |e|
        e.deep_symbolize_keys!

        # ignore events without locations
        next if e[:location].blank?

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
          identifiers: e[:identifiers],
          location: location
        )
      }
    end
  end
end

# import Emily's List data
import_events('emilys_list_events.yaml')

# import Resistance Calendar events
import_events('resistance_calendar_events.yaml')

