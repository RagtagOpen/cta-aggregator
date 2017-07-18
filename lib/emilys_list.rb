require 'nokogiri'
require 'httparty'

class EmilysList
  def events
    raw_page = HTTParty.get("http://www.emilyslist.org/pages/entry/events")
    page = Nokogiri::HTML(raw_page)
    events = []
    page.xpath('//h2[text()="Upcoming Events"]/following-sibling::p').each do |p|
      event = Hash.new

      date_and_location = p.css('strong').first

      next unless date_and_location

      date_loc_parts = date_and_location.text.split("\n")
      event['start_date'] = Date.parse(date_loc_parts[0])
      loc_parts = date_loc_parts[1].split(', ')
      event['location'] = {
        'locality': loc_parts[0],
        'region': loc_parts[1]
      }

      links = p.css('a')
      next unless links.first
      event['title'] = links.first.content
      event_url = p.xpath('./a[1]/@href').first.content
      event['browser_url'] = event_url

      # past events link to flickr sets, not event pages
      if /secure\.emilyslist\.org/ =~ event_url
        events << event
      end
    end
    events
  end
end
