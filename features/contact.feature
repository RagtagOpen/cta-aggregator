Feature: Contacts
  As a concerned citizen
  I want information about people associated with events 
  So that I can communicate with them

  Scenario: Retrieve a list of contacts
    Given the system contains the following contacts:
      | name              |  phone        | email                 | website |
      | Fred Flintstone   |  111-222-3333 | fred@aol.com          | www.hb.com |
      | Wilma Flintstone  |  444-555-6666 | wilma@aol.com         | www.wilma.com |
      | Barney Rubble     |  777-888-9999 | barney@compuserve.com | www.bBarneyRub.com |
    When the client requests a list of contacts
    Then the response contains three contacts
    Then the response contains a "name" attribute of "Fred Flintstone" 
    Then the response contains a "name" attribute of "Wilma Flintstone" 
    Then the response contains a "name" attribute of "Barney Rubble" 

  Scenario: Search for Contact that already exists
    Given the system contains the following contacts:
      | name              |  phone        | email                 | website |
      | Fred Flintstone   |  111-222-3333 | fred@aol.com          | www.hb.com |
      | Wilma Flintstone  |  444-555-6666 | wilma@aol.com         | www.wilma.com |
    And I send and accept JSON
    When I send a GET request to "/contacts?filter[email]=wilma@aol.com"
    Then the response status should be "200"
    Then the response contains an array with one contact
    Then the response contains an "email" attribute of "wilma@aol.com" 

  Scenario: Search for Contact that does not exist
    Given I send and accept JSON
    When I send a GET request to "/contacts?filter[email]=wilma@aol.com"
    Then the response status should be "200"
    Then the response contains zero locations

  Scenario: Create a Contact
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "contacts",
                "attributes": {
                                  "name": "Santa Claus",
                                  "phone": "123456789",
                                  "email": "Santa@example.com",
                                  "website": "www.darpa.gov"
                                }
              }
     }
    """
    When I send a POST request to "/contacts"
    Then the response status should be "201"
    Then the response contains the following attributes: 
      | attribute 	    | type      | value               |
      | name            | String    | Santa Claus         |
      | phone           | String    | 123456789           |
      | email           | String    | Santa@example.com   |
      | website         | String    | www.darpa.gov       |

  Scenario: Create a Contact with the minimal data
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "contacts",
                "attributes": {
                                  "name": "Santa Claus",
                                  "email": "Santa@example.com"
                                }
              }
     }
    """
    When I send a POST request to "/contacts"
    Then the response status should be "201"
    Then the response contains the following attributes: 
      | attribute 	    | type      | value             |
      | name            | String    | Santa Claus       |
      | email           | String    | Santa@example.com |
      | phone           | String    |                   |
      | website         | String    |                   |

  Scenario: Create a Contact with insufficient data
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "contacts",
                "attributes": {
                                  "name": "Santa Claus"
                                }
              }
     }
    """
    When I send a POST request to "/contacts"
    Then the response status should be "422"

  Scenario: Attempt to create duplicate Contact
    Given the system contains the following contacts:
      | name              |  phone        | email                 | website |
      | Santa Claus  |  123456789 | Santa@example.com          | www.darpa.gov |

    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "contacts",
                "attributes": {
                                  "name": "Santa Claus",
                                  "phone": "123456789",
                                  "email": "Santa@example.com",
                                  "website": "www.darpa.gov"
                                }
              }
     }
    """
    When I send a POST request to "/contacts"
    Then the response status should be "422"
