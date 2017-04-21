Feature: Call Scripts
  As a concerned citizen
  I want know what to say for certain calls to action
  So that I can make my voice heard

  Scenario: Retrieve a list of call scripts
    Given the system contains the following call scripts:
      | text                                        |
      | Lorem ipsum dolor sit amet                   |
      | consectetur adipiscing elit                  |
      | sed do eiusmod tempor incididunt ut labore   |
    Given the client sends and accepts JSON
    When the client sends a GET request to "/call_scripts"
    Then the response status should be "200"
    Then the response contains three call scripts
    And the response contains a "text" attribute of "Lorem ipsum dolor sit amet"
    And the response contains a "text" attribute of "consectetur adipiscing elit"
    And the response contains a "text" attribute of "sed do eiusmod tempor incididunt ut labore"

  Scenario: Create a Script
    Given the client sends and accepts JSON
    And the client sets a JWT in the authorization header
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "call_scripts",
         "attributes": {
            "text": "Lorem ipsum dolor sit amet"
          }
       }
    }
    """
    When the client sends a POST request to "/call_scripts"
    Then the response status should be "201"
    And the response contains the following attributes:
      | attribute 	 | type      | value                        |
      | text         | String    | Lorem ipsum dolor sit amet   |


  Scenario: Create a Script with insufficient data
    Given the client sends and accepts JSON
    And the client sets a JWT in the authorization header
    And the client sets the JSON request body to:
    """
     {
       "data": {
         "type": "call_scripts",
         "attributes": {
         }
       }
    }
    """
    When the client sends a POST request to "/call_scripts"
    Then the response status should be "422"

  Scenario: Attempt to create duplicate Script
    Given the system contains the following call scripts:
      | text                                        |
      | Lorem ipsum dolor sit amet                  |
    Given the client sends and accepts JSON
    And the client sets a JWT in the authorization header
    And the client sets the JSON request body to:
    """
    {
      "data": {
         "type": "call_scripts",
         "attributes": {
            "text": "Lorem ipsum dolor sit amet"
          }
       }
    }
    """
    When the client sends a POST request to "/call_scripts"
    Then the response status should be "422"
