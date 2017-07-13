require 'yaml'

namespace :five_calls do
  desc "Generate a yaml file from 5calls.org"
  task scrape: :environment do
    output_file = 'test/seeds/advocacy_campaigns.yaml'
    puts "-- scraping 5calls.org --"
    five_calls = ::FiveCalls.new()
    calls = five_calls.calls
    # transform into our format
    osdi_ctas = []
    calls.each do |call|
      unless call['inactive']
        targets = call['contacts'].map do |t|
          {
            organization: t['name'],
            phone_numbers: [t['phone']]
          }
        end
        cta = {
          origin_system: "5calls:#{call['id']}",
          title: call['name'],
          description: call['reason'],
          template: call['script'],
          action_type: 'phone',
          targets: targets
        }
        osdi_ctas << cta
      end
    end
    # write it to a seeds file
    File.open(output_file, 'w') {|f| f.write osdi_ctas.to_yaml } #Store
    puts "-- wrote #{calls.size} CTAs to #{output_file} --"
  end
end
