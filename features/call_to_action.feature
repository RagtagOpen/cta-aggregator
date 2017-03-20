Feature: Calls to Action
  As a concerned citizen
  I want information about political causes
  So that I can engage in causes I care about

  Scenario: Retrieve a list of calls to action
    Given the system contains the following calls to action:

      | title   | description | free| start_at             | end_at              | event_type  | website         |
      | CTA One  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Three  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |


    When the client requests the list of calls to action
    Then the response will contain three calls to action
    Then one call to action has a the a "title" attributes of "CTA One" 
    Then one call to action has a the a "title" attributes of "CTA Two" 
    Then one call to action has a the a "title" attributes of "CTA Three" 

  Scenario: Retrieve a call to action
    Given the system contains a contact with uuid "aaaaaaaa-1111-2222-3333-666666666666" 
    Given the system contains the following calls to action:
      | title   | description | free| start_at             | end_at               | event_type   | website |
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14  |  2018-05-19 14:30:14 | onsite        | www.example.com |
    When the client requestes the call to action containing the title "foobar"
    Then the response will contain one call to action
    Then one call to action has the following attributes: 
      | attribute 	    | type      | value             |
      | title	  	      | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | website  	      | String    | www.example.com   |
      | event-type      | String    | onsite            |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |

   Scenario: Creates a call to action
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "call_to_actions",
                "attributes": {
                                "title": "foobar",
                                "description": "Lorem ipsum",
                                "free": true,
                                "start-time": "1526725814",
                                "end-time": "1526740214",
                                "event-type": "phone",
                                "website": "www.example.com"
                              }
               }
       }
    """
    When I send a POST request to "/call_to_actions"
    Then the response status should be "201"
    Then the response contains the following attributes:
      | attribute 	    | type      | value             |
      | title	  	      | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |
      | website  	      | String    | www.example.com   |
      | event-type      | String    | phone             |


   Scenario: Add location for call to action
    Given the system contains a call to action with uuid "aaaaaaaa-1111-2222-3333-666666666666"
    Given the system contains a location with uuid "bbbbbbbb-1111-2222-3333-666666666666"
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "locations",
                "id": "bbbbbbbb-1111-2222-3333-666666666666"
                }
     }
    """
    When I send a PUT request to "/call_to_actions/aaaaaaaa-1111-2222-3333-666666666666/relationships/location"
    Then the response status should be "204"

   Scenario: Add contact for call to action
    Given the system contains a call to action with uuid "aaaaaaaa-1111-2222-3333-666666666666" 
    Given the system contains a contact with uuid "cccccccc-1111-2222-3333-666666666666"
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
     "data": [
               {
                  "id": "cccccccc-1111-2222-3333-666666666666",
                  "type": "contacts"
                  }
             ]
     }
    """
    When I send a POST request to "/call_to_actions/aaaaaaaa-1111-2222-3333-666666666666/relationships/contacts"
    Then the response status should be "204"

  Scenario: Create a call to action with insufficient data
    Given I send and accept JSON
    And   I set JSON request body to:
    """
     {
      "data": {
                "type": "call_to_actions",
                        "attributes": {
                                       "title": "cool titile"
                                      }
              }
     }
    """
    When I send a POST request to "/call_to_actions"
    Then the response status should be "422"

    @active
  Scenario: Attempt to create duplicate Call to Action
    Given the system contains the following calls to action:
      | title   | description | free| start_at             | end_at              | event_type  | website         |
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
    And I send and accept JSON
    And I set JSON request body to:
    """
     {
      "data": {
                "type": "call_to_actions",
                "attributes": {
                                "title": "foobar",
                                "description": "Lorem ipsum",
                                "free": true,
                                "start-time": "1526725814",
                                "end-time": "1526740214",
                                "event-type": "phone",
                                "website": "www.example.com"
                              }
               }
     }
    """
    When I send a POST request to "/call_to_actions"
    Then the response status should be "422"
