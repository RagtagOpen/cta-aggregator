Feature: Locations
  As a concerned citizen
  I want information where events take place
  So that I can engage in causes I care about

  Scenario: Retrieve a list of locations
    Given the system contains the following locations:
      | address_line_1    |  city     | state | zipcode |
      | 123 Fake Street   | Fakeville | CA    | 91666		|
      | 456 Fake Street   | Gotham    | NY    | 91133		|
      | 789 Fake Street   | Dallas    | TX    | 60612		|
    Given the client sends and accepts JSON
    When the client sends a GET request to "/locations"
    Then the response status should be "200"
    Then the response contains three locations
    And the response contains an "address_line_1" attribute of "123 Fake Street"
    And the response contains an "address_line_1" attribute of "456 Fake Street"
    And the response contains an "address_line_1" attribute of "789 Fake Street"

  Scenario: Search for Location that already exists
    Given the system contains the following locations:
      | address_line_1  |  city     | state | zipcode |
      | 123 Fake Street | Fakeville | CA    | 91666		|
      | 456 Fake Street | Gotham    | CA    | 91123		|
    Given the client sends and accepts JSON
    When the client sends a GET request to "/locations?filter[state]=CA&filter[zipcode]=91666"
    Then the response status should be "200"
    And the response contains an array with one location
    And the response contains an "address_line_1" attribute of "123 Fake Street"

  Scenario: Search for Location that does not exist
    Given the client sends and accepts JSON
    When the client sends a GET request to "/locations?address-line-1=123fakestreet"
    Then the response status should be "200"
    Then the response contains zero locations

  Scenario: Create a Location
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
       "data": {
          "type": "locations",
          "attributes": {
             "address-line-1": "123 Fake Street",
             "address-line-2": "Suite 1500",
             "city": "San Francisco",
             "state": "CA",
             "zipcode": "12345",
             "notes": "Head to front desk"
          }
       }
    }
    """
    When the client sends a POST request to "/locations"
    Then the response status should be "201"
    And the response contains the following attributes:
      | attribute 	    | type      | value             |
      | address-line-1  | String    | 123 Fake Street   |
      | address-line-2  | String    | Suite 1500        |
      | city            | String    | San Francisco     |
      | state           | String    | CA                |
      | zipcode         | String    | 12345             |
      | notes           | String    | Head to front desk|

  Scenario: Create a Location with minimal data
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "locations",
         "attributes": {
            "address-line-1": "123 Fake Street",
             "city": "San Francisco",
             "state": "CA",
             "zipcode": "12345"
          }
       }
    }
    """
    When the client sends a POST request to "/locations"
    Then the response status should be "201"
    And the response contains the following attributes:
      | attribute 	    | type      | value             |
      | address-line-1  | String    | 123 Fake Street   |
      | address-line-2  | String    |                   |
      | city            | String    | San Francisco     |
      | state           | String    | CA                |
      | zipcode         | String    | 12345             |
      | notes           | String    |                   |


  Scenario: Create a Location with insufficient data
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "locations",
          "attributes": {
          "address-line-1": "123 Fake Street"
         }
       }
    }
    """
    When the client sends a POST request to "/locations"
    Then the response status should be "422"

  Scenario: Attempt to create duplicate Location
    Given the system contains the following locations:
      | address_line_1     |  city     | state | zipcode |
      | 123 Fake Street    | Fakeville | CA    | 91666	 |
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "locations",
          "attributes": {
             "address-line-1": "123 Fake Street",
             "city": "Fakeville",
             "state": "CA",
             "zipcode": "91666"
           }
       }
    }
    """
    When the client sends a POST request to "/locations"
    Then the response status should be "422"
