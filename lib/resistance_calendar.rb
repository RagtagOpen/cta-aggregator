require 'rest-client'
require 'json'

class ResistanceCalendar
  # This only gets the first page, for now
  def events
    url = "https://resistance-calendar.herokuapp.com/v1/events?page=0&per_page=25&$orderby=start_date%20desc&$filter=start_date%20gt%20#{Time.now.utc.iso8601}"
    puts "fetching #{url}"
    response = RestClient.get(url)
    JSON.parse(response)['_embedded']['osdi:events']
  end
end
