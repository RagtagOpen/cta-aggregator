Feature: Calls to Action
  As a concerned citizen
  I want information about political causes
  So that I can engage in causes I care about

  Scenario: User retrieves a list of calls to action
    Given the system contains the following calls to action:
      | title     |
      | CTA One   |
      | CTA Two   |
      | CTA Three |

    When the client requests a list of calls to action
    Then the response contains three calls to action
    Then one call to action has a the a "title" attributes of "CTA One" 
    Then one call to action has a the a "title" attributes of "CTA Two" 
    Then one call to action has a the a "title" attributes of "CTA Three" 

  @active
  Scenario: User retrieves a call to action
    Given the system contains the following calls to action:
      | title   | description | free| start_at             | end_at             | action_type|
      | foobar  | Lorem ipsum | true| 2018-05-19 10:30:14  |  2018-05-19 14:30:14 | onsite     |

    When the client requestes the call to action containing the title "foobar"
    Then the response contains one call to action
    Then one call to action has the following attributes: 
      | attribute 	    | type      | value             |
      | title	  	      | String    | foobar            |
      | description     | String    | Lorem ipsum       |
      | free            | TrueClass | true              |
      | start-time      | Integer   | 1526725814        |
      | end-time        | Integer   | 1526740214        |

  # Scenario: User creates a call to action
  
