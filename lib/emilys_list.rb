require 'wombat'

class EmilysList
  def events
    result = Wombat.crawl do
      base_url "http://www.emilyslist.org/"
      path "/pages/entry/events"

      events "xpath=//h2[text()=\"Upcoming Events\"]/following-sibling::p", :iterator do
        title 'css=a'
        date_and_location 'css=strong'
        browser_url 'xpath=.//a[1]/@href'
        # details 'xpath=..//a[1]/@href', :follow do
        #   description 'xpath=.//div[@class="bsd-contribForm-aboveContent"]/h1[1]'
        #   date_and_time 'xpath=.//p[1]'
        #   location 'xpath=.//p[2]'
        # end
      end
    end
    events = result['events'].reject{ |e| e['title'].blank? }
    events.each do |e|
      puts "massaging #{e}"
      date_loc_parts = e['date_and_location'].split("\n")
      e['start_date'] = Date.parse(date_loc_parts[0])
      loc_parts = date_loc_parts[1].split(', ')
      e['location'] = {
        'locality': loc_parts[0],
        'region': loc_parts[1]
      }
      e.delete 'date_and_location'
      id = e['browser_url'].sub('https://secure.emilyslist.org/page/contribute/', '')
      e['origin_system'] = "emilyslist:#{id}"
    end
    events
  end
end
