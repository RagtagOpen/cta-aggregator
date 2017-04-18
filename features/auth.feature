Feature: Authentication
  As an API consumer
  I want to authenticate myself to the api
  So that securely interact with the api

  Scenario: Send the correct api key and token
    Given the system contains the following users:
      | email           | password | password_confirmation | api_key |
      | foo@example.com | secret   | secret                | 12345   |
    And the client sends and accepts JSON
    And the client sets an authentication header to "12345:secret"
    When the client sends a POST request to "/authorize"
    Then the response status should be "201"
    And the response contains a JWT for a user with email foo@example.com

  Scenario: Send an incorrect token
    Given the system contains the following users:
      | email           | password | password_confirmation | api_key |
      | foo@example.com | secret   | secret                | 12345   |
    And the client sends and accepts JSON
    And the client sets an authentication header to "12345:incorrect"
    When the client sends a POST request to "/authorize"
    Then the response status should be "404"

  Scenario: Send an incorrect api key
    Given the system contains the following users:
      | email           | password | password_confirmation | api_key |
      | foo@example.com | secret   | secret                | 12345   |
    And the client sends and accepts JSON
    And the client sets an authentication header to "125:secret"
    When the client sends a POST request to "/authorize"
    Then the response status should be "404"

  Scenario: JWT Authenticated Request
    Given the system contains the following users:
      | email           | password | password_confirmation | api_key |
      | foo@example.com | secret   | secret                | 12345   |
    And the client sends and accepts JSON
    And the client sets an authorization header with a JWT for a user with email: foo@example.com
    And the client sets the JSON request body to:
    """
    {
       "data": {
          "type": "locations",
          "attributes": {
             "address": "123 Fake Street",
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

  @time_travel
  Scenario: JWT Authenticated Request with an expired token
    Given the system contains the following users:
      | email           | password | password_confirmation | api_key |
      | foo@example.com | secret   | secret                | 12345   |
    And the client sends and accepts JSON
    And the client sets an authorization header with a JWT for a user with email: foo@example.com
    And the client sets the JSON request body to:
    """
    {
       "data": {
          "type": "locations",
          "attributes": {
             "address": "123 Fake Street",
             "city": "San Francisco",
             "state": "CA",
             "zipcode": "12345",
             "notes": "Head to front desk"
          }
       }
    }
    """
    When the token expires
    And the client sends a POST request to "/locations"
    Then the response status should be "401"

  Scenario: JWT Authenticated Request with a malformed token
    Given the system contains the following users:
      | email           | password | password_confirmation | api_key |
      | foo@example.com | secret   | secret                | 12345   |
    And the client sends and accepts JSON
    And the client sets a malformed JWT in the authorization header
    And the client sets the JSON request body to:
    """
    {
       "data": {
          "type": "locations",
          "attributes": {
             "address": "123 Fake Street",
             "city": "San Francisco",
             "state": "CA",
             "zipcode": "12345",
             "notes": "Head to front desk"
          }
       }
    }
    """
    When the client sends a POST request to "/locations"
    Then the response status should be "401"
