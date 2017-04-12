Feature: CTAs
  As a concerned citizen
  I want information about political causes
  So that I can engage in causes I care about

  Scenario: Retrieve a list of CTAs
    Given the system contains the following ctas:
      | title    | description | free| start_at             | end_at              | cta_type   | website         |
      | CTA One  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Three| Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
    When the client sends a GET request to "/ctas"
    Then the response status should be "200"
    Then the response contains three ctas
    And the response contains a "title" attribute of "CTA One" 
    And the response contains a "title" attribute of "CTA Two" 
    And the response contains a "title" attribute of "CTA Three" 

  Scenario: Retrieve a list of upcoming ctas
    Given the system contains the following ctas:
      | title    | description | free| start_at             | end_at              | cta_type   | website         |
      | CTA One  | Lorem ipsum | true| 2012-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2038-01-18 03:14:07  | 2038-01-18 03:14:07 | onsite       | www.example.com |
      | CTA Three| Lorem ipsum | true| 2036-02-06 03:14:07  | 2036-02-06 03:14:07 | phone        | www.example.com |
    When the client sends a GET request to "/ctas?filter[upcoming]=true"
    Then the response status should be "200"
    Then the response contains two ctas
    And the response contains a "title" attribute of "CTA Two"
    And the response contains a "title" attribute of "CTA Three"

  Scenario: Retrieve a list of ctas filtered by phone cta type
    Given the system contains the following ctas:
      | title    | description | free| start_at             | end_at              | cta_type   | website         |
      | CTA One  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Three| Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
    When the client sends a GET request to "/ctas?filter[cta-type]=onsite"
    Then the response status should be "200"
    Then the response contains two cta
    And the response contains a "title" attribute of "CTA One"
    And the response contains a "title" attribute of "CTA Two"

  Scenario: Retrieve a list of cta filtered by phone cta type
    Given the system contains the following ctas:
      | title    | description | free| start_at             | end_at              | cta_type   | website         |
      | CTA One  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | onsite       | www.example.com |
      | CTA Two  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
      | CTA Three| Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone        | www.example.com |
    When the client sends a GET request to "/ctas?filter[cta-type]=phone"
    Then the response status should be "200"
    Then the response contains two ctas
    And the response contains a "title" attribute of "CTA Two"
    And the response contains a "title" attribute of "CTA Three"

  Scenario: Retrieve an CTA
    Given the system contains the following ctas:
      | title   | description | free| start_at           | end_at               | cta_type | website         | uuid                                 |
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14|  2018-05-19 14:30:14 | onsite     | www.example.com | aaaaaaaa-1111-2222-3333-666666666666 |
    And the client sends and accepts JSON
    When the client sends a GET request to "/ctas/aaaaaaaa-1111-2222-3333-666666666666"
    Then the response status should be "200"
    And the response contains one cta
    And the response contains the following attributes:
      | attribute 	    | type      | value             |
      | title	  	      | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | website  	      | String    | www.example.com   |
      | cta-type        | String    | onsite            |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |

   Scenario: Create an CTA with contact, location, and call script
    Given the system contains a location with uuid "bbbbbbbb-1111-2222-3333-666666666666"
    Given the system contains a contact with uuid "cccccccc-1111-2222-3333-666666666666"
    Given the system contains a call script with uuid "dddddddd-1111-2222-3333-666666666666"
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "ctas",
         "attributes": {
            "title": "foobar",
            "description": "Lorem ipsum",
            "free": true,
            "start-time": "1526725814",
            "end-time": "1526740214",
            "cta-type": "phone",
            "website": "www.example.com"
          },
          "relationships": {
            "location": {
              "data": { "type": "locations", "id": "bbbbbbbb-1111-2222-3333-666666666666" }
            },
            "contact": {
              "data": { "type": "contacts", "id": "cccccccc-1111-2222-3333-666666666666" }
            },
            "call-script": {
              "data": { "type": "call-scripts", "id": "dddddddd-1111-2222-3333-666666666666" }
            }
          }
       }
    }
    """
    When the client sends a POST request to "/ctas"
    Then the response status should be "201"
    And the response contains the following attributes:
      | attribute       | type      | value             |
      | title           | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |
      | website         | String    | www.example.com   |
      | cta-type        | String    | phone             |
    And the cta has a location_id of "bbbbbbbb-1111-2222-3333-666666666666"
    And the cta has a contact_id of "cccccccc-1111-2222-3333-666666666666"
    And the cta has a call_script_id of "dddddddd-1111-2222-3333-666666666666"

   Scenario: Create an CTA
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "ctas",
         "attributes": {
            "title": "foobar",
            "description": "Lorem ipsum",
            "free": true,
            "start-time": "1526725814",
            "end-time": "1526740214",
            "cta-type": "phone",
            "website": "www.example.com"
          }
       }
    }
    """
    When the client sends a POST request to "/ctas"
    Then the response status should be "201"
    And the response contains the following attributes:
      | attribute       | type      | value             |
      | title           | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |
      | website         | String    | www.example.com   |
      | cta-type       | String    | phone             |

   Scenario: Add location for CTA
    Given the system contains a cta with uuid "aaaaaaaa-1111-2222-3333-666666666666"
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
    When the client sends a PUT request to "/ctas/aaaaaaaa-1111-2222-3333-666666666666/relationships/location"
    Then the response status should be "204"

   Scenario: Add contact for CTA
    Given the system contains a cta with uuid "aaaaaaaa-1111-2222-3333-666666666666" 
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
    When the client sends a PUT request to "/ctas/aaaaaaaa-1111-2222-3333-666666666666/relationships/contact"
    Then the response status should be "204"

   Scenario: Add call script for CTA
    Given the system contains a cta with uuid "aaaaaaaa-1111-2222-3333-666666666666" 
    Given the system contains a call script with uuid "dddddddd-1111-2222-3333-666666666666"
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
     {
       "data": {
         "type": "call-scripts",
         "id": "dddddddd-1111-2222-3333-666666666666" 
       }
    }
    """
    When the client sends a PUT request to "/ctas/aaaaaaaa-1111-2222-3333-666666666666/relationships/call_script"
    Then the response status should be "204"


  Scenario: Create a CTA with insufficient data
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "ctas",
          "attributes": {
             "title": "cool title"
          }
       }
    }
    """
    When the client sends a POST request to "/ctas"
    Then the response status should be "422"

  Scenario: Attempt to create duplicate CTAs
    Given the system contains the following ctas:
      | title   | description | free| start_at             | end_at              | cta_type  | website         |
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14  | 2018-05-19 14:30:14 | phone       | www.example.com |
    Given the client sends and accepts JSON
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "ctas",
          "attributes": {
            "title": "foobar",
            "description": "Lorem ipsum",
            "free": true,
            "start-time": "1526725814",
            "end-time": "1526740214",
            "cta-type": "phone",
            "website": "www.example.com"
          }
       }
    }
    """
    When the client sends a POST request to "/ctas"
    Then the response status should be "422"
