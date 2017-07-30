require 'yaml'

namespace :five_calls do
  desc "Generate a yaml file from 5calls.org"
  task download: :environment do
    output_file = 'db/seeds/5calls_advocacy_campaigns.yaml'
    puts "-- downloading 5calls.org --"
    five_calls = ::FiveCalls.new()
    calls = five_calls.calls
    # transform into our format
    osdi_ctas = []
    calls.each do |call|
      # skip if there's nobody to call (this is the location-indepent data)
      next if call['contacts'].empty?
      # skip if it's inactive
      next if call['inactive']
      targets = call['contacts'].map do |t|
        {
          organization: t['name'],
          phone_numbers: [{
            primary: true,
            number: t['phone'],
            number_type: 'work'
          }]
        }
      end
      cta = {
        origin_system: "5calls:#{call['id']}",
        title: call['name'],
        description: call['reason'],
        template: call['script'],
        action_type: 'phone',
        target_list: targets
      }
      osdi_ctas << cta
    end
    # write it to a seeds file
    File.open(output_file, 'w') {|f| f.write osdi_ctas.to_yaml } #Store
    puts "-- wrote #{calls.size} CTAs to #{output_file} --"
  end
end
