Feature: User CRUD API Tests

  Background:
    * url baseUrl

  Scenario: Get all users
    Given path '/users'
    When method GET
    Then status 200
    And match response == '#[]'