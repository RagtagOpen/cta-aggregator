require 'yaml'

namespace :resistance_calendar do
  desc "Generate a yaml file from Resistance Calendar"
  task download: :environment do
    output_file = 'db/seeds/resistance_calendar_events.yaml'
    puts "-- downloading Resistance Calendar events --"
    resistance_calendar = ::ResistanceCalendar.new()
    events = resistance_calendar.events
    puts "events: #{events}"
    # write it to a seeds file
    File.open(output_file, 'w') {|f| f.write events.to_yaml } #Store
    puts "-- wrote #{events.size} events to #{output_file} --"
  end
end
