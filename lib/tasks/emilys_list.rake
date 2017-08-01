require 'yaml'

namespace :emilys_list do
  desc "Generate a yaml file from emilyslist.org"
  task download: :environment do
    output_file = 'db/seeds/emilys_list_events.yaml'
    puts "-- downloading emilyslist.org events --"
    emilys_list = ::EmilysList.new()
    events = emilys_list.events
    puts "events: #{events}"
    # write it to a seeds file
    File.open(output_file, 'w') {|f| f.write events.to_yaml } #Store
    puts "-- wrote #{events.size} events to #{output_file} --"
  end
end
