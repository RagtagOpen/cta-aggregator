Feature: Events
  As a concerned citizen
  I want information about political causes
  So that I can engage in causes I care about

  Scenario: Retrieve a list of events
    Given the system contains the following events:
      | title    | description | free| start_at             | end_at              | event_type   | website         |
      | CTA One  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Three| Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
    When the client sends a GET request to "/events"
    Then the response status should be "200"
    Then the response contains three events
    And the response contains a "title" attribute of "CTA One" 
    And the response contains a "title" attribute of "CTA Two" 
    And the response contains a "title" attribute of "CTA Three" 

  Scenario: Retrieve a list of upcoming events
    Given the system contains the following events:
      | title    | description | free| start_at             | end_at              | event_type   | website         |
      | CTA One  | Lorem ipsum | true| 2012-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2038-01-18 03:14:07  | 2038-01-18 03:14:07 | onsite       | www.example.com |
      | CTA Three| Lorem ipsum | true| 2036-02-06 03:14:07  | 2036-02-06 03:14:07 | phone        | www.example.com |
    When the client sends a GET request to "/events?filter[upcoming]=true"
    Then the response status should be "200"
    Then the response contains two events
    And the response contains a "title" attribute of "CTA Two"
    And the response contains a "title" attribute of "CTA Three"

  Scenario: Retrieve a list of events filtered by phone event type
    Given the system contains the following events:
      | title    | description | free| start_at             | end_at              | event_type   | website         |
      | CTA One  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Three| Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
    When the client sends a GET request to "/events?filter[event-type]=onsite"
    Then the response status should be "200"
    Then the response contains two events
    And the response contains a "title" attribute of "CTA One"
    And the response contains a "title" attribute of "CTA Two"

  Scenario: Retrieve a list of events filtered by phone event type
    Given the system contains the following events:
      | title    | description | free| start_at             | end_at              | event_type   | website         |
      | CTA One  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Three| Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
    When the client sends a GET request to "/events?filter[event-type]=phone"
    Then the response status should be "200"
    Then the response contains two events
    And the response contains a "title" attribute of "CTA Two"
    And the response contains a "title" attribute of "CTA Three"

  Scenario: Retrieve an event
    Given the system contains the following events:
      | title   | description | free| start_at           | end_at               | event_type | website         | uuid                                 |
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14|  2018-05-19 14:30:14 | onsite     | www.example.com | aaaaaaaa-1111-2222-3333-666666666666 |
    And the client sends and accepts JSON
    When the client sends a GET request to "/events/aaaaaaaa-1111-2222-3333-666666666666"
    Then the response status should be "200"
    And the response contains one event
    And the response contains the following attributes:
      | attribute 	    | type      | value             |
      | title	  	      | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | website  	      | String    | www.example.com   |
      | event-type      | String    | onsite            |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |

   Scenario: Create an event with contact and location
    Given the system contains a location with uuid "bbbbbbbb-1111-2222-3333-666666666666"
    Given the system contains a contact with uuid "cccccccc-1111-2222-3333-666666666666"
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "events",
         "attributes": {
            "title": "foobar",
            "description": "Lorem ipsum",
            "free": true,
            "start-time": "1526725814",
            "end-time": "1526740214",
            "event-type": "phone",
            "website": "www.example.com"
          },
          "relationships": {
            "location": {
              "data": { "type": "locations", "id": "bbbbbbbb-1111-2222-3333-666666666666" }
            },
            "contact": {
              "data": { "type": "contacts", "id": "cccccccc-1111-2222-3333-666666666666" }
            }
          }
       }
    }
    """
    When the client sends a POST request to "/events"
    Then the response status should be "201"
    And the response contains the following attributes:
      | attribute       | type      | value             |
      | title           | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |
      | website         | String    | www.example.com   |
      | event-type      | String    | phone             |
    And the event has a location_id of "bbbbbbbb-1111-2222-3333-666666666666"
    And the event has a contact_id of "cccccccc-1111-2222-3333-666666666666"

   Scenario: Create an event
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "events",
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
    When the client sends a POST request to "/events"
    Then the response status should be "201"
    And the response contains the following attributes:
      | attribute       | type      | value             |
      | title           | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |
      | website         | String    | www.example.com   |
      | event-type      | String    | phone             |

   Scenario: Add location for event
    Given the system contains a event with uuid "aaaaaaaa-1111-2222-3333-666666666666"
    Given the system contains a location with uuid "bbbbbbbb-1111-2222-3333-666666666666"
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "locations",
         "id": "bbbbbbbb-1111-2222-3333-666666666666"
       }
    }
    """
    When the client sends a PUT request to "/events/aaaaaaaa-1111-2222-3333-666666666666/relationships/location"
    Then the response status should be "204"

   Scenario: Add contact for event
    Given the system contains a event with uuid "aaaaaaaa-1111-2222-3333-666666666666" 
    Given the system contains a contact with uuid "cccccccc-1111-2222-3333-666666666666"
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
     {
       "data": {
          "type": "contacts",
          "id": "cccccccc-1111-2222-3333-666666666666"
       }
    }
    """
    When the client sends a PUT request to "/events/aaaaaaaa-1111-2222-3333-666666666666/relationships/contact"
    Then the response status should be "204"

  Scenario: Create a event with insufficient data
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "events",
          "attributes": {
             "title": "cool title"
          }
       }
    }
    """
    When the client sends a POST request to "/events"
    Then the response status should be "422"

  Scenario: Attempt to create duplicate Event
    Given the system contains the following events:
      | title   | description | free| start_at             | end_at              | event_type  | website         |
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone       | www.example.com |
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "events",
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
    When the client sends a POST request to "/events"
    Then the response status should be "422"
