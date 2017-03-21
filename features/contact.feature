Feature: Contacts
  As a concerned citizen
  I want information about people associated with events 
  So that I can communicate with them

  Scenario: Retrieve a list of contacts
    Given the system contains the following contacts:
      | name              |  phone        | email                 | website           |
      | Fred Flintstone   |  111-222-3333 | fred@aol.com          | www.hb.com        |
      | Wilma Flintstone  |  444-555-6666 | wilma@aol.com         | www.wilma.com     |
      | Barney Rubble     |  777-888-9999 | barney@compuserve.com | www.BarneyRub.com |
    Given the client sends and accepts JSON
    When the client sends a GET request to "/contacts"
    Then the response contains three contacts
    And the response contains a "name" attribute of "Fred Flintstone" 
    And the response contains a "name" attribute of "Wilma Flintstone" 
    And the response contains a "name" attribute of "Barney Rubble" 

  Scenario: Search for Contact that already exists
    Given the system contains the following contacts:
      | name              |  phone        | email                 | website       |
      | Fred Flintstone   |  111-222-3333 | fred@aol.com          | www.hb.com    |
      | Wilma Flintstone  |  444-555-6666 | wilma@aol.com         | www.wilma.com |
    Given the client sends and accepts JSON
    When the client sends a GET request to "/contacts?filter[email]=wilma@aol.com"
    Then the response status should be "200"
    And the response contains an array with one contact
    And the response contains an "email" attribute of "wilma@aol.com" 

  Scenario: Search for Contact that does not exist
    Given the client sends and accepts JSON
    When the client sends a GET request to "/contacts?filter[email]=wilma@aol.com"
    Then the response status should be "200"
    And the response contains zero locations

  Scenario: Create a Contact
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "contacts",
         "attributes": {
            "name": "Santa Claus",
            "phone": "123456789",
            "email": "santa@example.com",
            "website": "www.darpa.gov"
          }
       }
    }
    """
    When the client sends a POST request to "/contacts"
    Then the response status should be "201"
    And the response contains the following attributes: 
      | attribute 	    | type      | value               |
      | name            | String    | Santa Claus         |
      | phone           | String    | 123456789           |
      | email           | String    | santa@example.com   |
      | website         | String    | www.darpa.gov       |

  Scenario: Create a Contact with the minimal data
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "contacts",
         "attributes": {
            "name": "Santa Claus",
            "email": "santa@example.com"
          }
       }
    }
    """
    When the client sends a POST request to "/contacts"
    Then the response status should be "201"
    Then the response contains the following attributes: 
      | attribute 	    | type      | value             |
      | name            | String    | Santa Claus       |
      | email           | String    | santa@example.com |
      | phone           | String    |                   |
      | website         | String    |                   |

  Scenario: Create a Contact with insufficient data
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
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
    When the client sends a POST request to "/contacts"
    Then the response status should be "422"

  Scenario: Attempt to create duplicate Contact
    Given the system contains the following contacts:
      | name         |  phone     | email             | website       |
      | Santa Claus  |  123456789 | santa@example.com | www.darpa.gov |
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "contacts",
         "attributes": {
            "name": "Santa Claus",
            "phone": "123456789",
            "email": "santa@example.com",
            "website": "www.darpa.gov"
          }
       }
    }
    """
    When the client sends a POST request to "/contacts"
    Then the response status should be "422"
