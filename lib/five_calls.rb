require 'rest-client'
require 'json'

class FiveCalls
  def calls
    url = 'https://5calls.org/issues/'
    response = RestClient.get(url)
    JSON.parse(response)['issues']
  end
end
