Feature: Locations
  As a concerned citizen
  I want information where events take place
  So that I can engage in causes I care about

  Scenario: Retrieve a list of locations
    Given the system contains the following locations:
      | address_line1     |  city     | state | postal_code |
      | 123 Fake Street   | Fakeville | CA    | 91666				|
      | 456 Fake Street   | Gotham    | NY    | 91133				|
      | 789 Fake Street   | Dallas    | TX    | 60612				|

    When the client requests a list of locations
    Then the response contains three locations
    Then the response contains an "address_line1" attribute of "123 Fake Street"
    Then the response contains an "address_line1" attribute of "456 Fake Street"
    Then the response contains an "address_line1" attribute of "789 Fake Street"

  Scenario: Search for Location that already exists
    Given the system contains the following locations:
      | address_line1     |  city     | state | postal_code |
      | 123 Fake Street   | Fakeville | CA    | 91666 			|
      | 456 Fake Street   | Gotham    | CA    | 91123 			|
    And I send and accept JSON
    When I send a GET request to "/locations?filter[state]=CA&filter[postal_code]=91666"
    Then the response status should be "200"
    Then the response contains an array with one location
    Then the response contains an "address_line1" attribute of "123 Fake Street"

  Scenario: Search for Location that does not exist
    Given I send and accept JSON
    When I send a GET request to "/locations?address-line1=123fakestreet"
    Then the response status should be "200"
    Then the response contains zero locations

  Scenario: Create a Location
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "locations",
                "attributes": {
                                  "address-line1": "123 Fake Street",
                                  "address-line2": "Suite 1500",
                                  "city": "San Francisco",
                                  "state": "CA",
                                  "postal-code": "12345",
                                  "notes": "Head to front desk"
                                }
              }
     }
    """
    When I send a POST request to "/locations"
    Then the response status should be "201"
    Then the response contains the following attributes:
      | attribute 	    | type      | value             |
      | address-line1   | String    | 123 Fake Street   |
      | address-line2   | String    | Suite 1500        |
      | city            | String    | San Francisco     |
      | state           | String    | CA                |
      | postal-code     | String    | 12345             |
      | notes           | String    | Head to front desk|

  Scenario: Create a Location with minimal data
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "locations",
                "attributes": {
                                  "address-line1": "123 Fake Street",
                                  "city": "San Francisco",
                                  "state": "CA",
                                  "postal-code": "12345"
                                }
              }
     }
    """
    When I send a POST request to "/locations"
    Then the response status should be "201"
    Then the response contains the following attributes:
      | attribute 	    | type      | value             |
      | address-line1   | String    | 123 Fake Street   |
      | address-line2   | String    |                   |
      | city            | String    | San Francisco     |
      | state           | String    | CA                |
      | postal-code     | String    | 12345             |
      | notes           | String    |                   |


  Scenario: Create a Location with insufficient data
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "locations",
                        "attributes": {
                                       "address-line1": "123 Fake Street"
                                      }
              }
     }
    """

    When I send a POST request to "/locations"
    Then the response status should be "422"

  Scenario: Attempt to create duplicate Location
    Given the system contains the following locations:
      | address_line1     |  city     | state | postal_code |
      | 123 Fake Street   | Fakeville | CA    | 91666 			|

    And I send and accept JSON
    And I set JSON request body to:
    """
     {
      "data": {
                "type": "locations",
                        "attributes": {
                                      "address-line1": "123 Fake Street",
                                      "city": "Fakeville",
                                      "state": "CA",
                                      "postal-code": "91666"
                                      }
              }
     }
    """

    When I send a POST request to "/locations"
    Then the response status should be "422"
