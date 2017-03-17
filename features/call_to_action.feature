Feature: Calls to Action
  As a concerned citizen
  I want information about political causes
  So that I can engage in causes I care about

  Scenario: Retrieve a list of calls to action
    Given the system contains the following calls to action:
      | title     |
      | CTA One   |
      | CTA Two   |
      | CTA Three |

    When the client requests the list of calls to action
    Then the response will contain three calls to action
    Then one call to action has a the a "title" attributes of "CTA One" 
    Then one call to action has a the a "title" attributes of "CTA Two" 
    Then one call to action has a the a "title" attributes of "CTA Three" 

  Scenario: Retrieve a call to action
    Given the system contains the following calls to action:
      | title   | description | free| start_at             | end_at             | action_type|
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14  |  2018-05-19 14:30:14 | onsite     |

    When the client requestes the call to action containing the title "foobar"
    Then the response will contain one call to action
    Then one call to action has the following attributes: 
      | attribute 	    | type      | value             |
      | title	  	      | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |
      | location        | Location  | nil               |

  # Scenario: Creates a call to action
  
