
Feature: User CRUD API Tests

  Background:
    * url baseUrl
    * print 'Starting User CRUD tests with baseUrl:', baseUrl
    * def basePath = 'users'
    # Initialize Faker
    * def JavaFaker = Java.type('com.github.javafaker.Faker')
    * def faker = new JavaFaker()
    # Generate random data
    * def randomFirstName = faker.name().firstName()
    * def randomLastName = faker.name().lastName()
    * def randomEmail = faker.internet().emailAddress()
    * def randomPhone = '30' + faker.number().digits(8)
    * def testUser =
      """
      {
        "firstName": "#(randomFirstName)",
        "lastName": "#(randomLastName)",
        "email": "#(randomEmail)",
        "phone": "#(randomPhone)"
      }
      """

  Scenario: Get all users - returns list
    Given path basePath
    When method GET
    Then status 200
    And match response == '#[]'

  Scenario: Create a new user successfully
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    And match response.firstName == randomFirstName
    And match response.lastName == randomLastName
    And match response.email == randomEmail
    And match response.id == '#number'
    And match response.phone == '#string'
    * def createdUserId = response.id

  Scenario: Create user and verify in get all users
    # Create user
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userId = response.id
    * def userEmail = response.email

    # Verify user appears in list
    Given path basePath
    When method GET
    Then status 200
    And match response == '#[]'
    And match response[*].id contains userId
    And match response[*].email contains userEmail

  Scenario: Get user by ID
    # Create user first
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userId = response.id

    # Get user by ID
    Given path basePath, userId
    When method GET
    Then status 200
    And match response.id == userId
    And match response.firstName == randomFirstName
    And match response.lastName == randomLastName
    And match response.email == randomEmail

  Scenario: Get user by ID - not found
    Given path basePath, 99999
    When method GET
    Then status 404

  Scenario: Get user by email
    # Create user first
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userEmail = response.email

    # Get user by email
    Given path basePath, 'email', userEmail
    When method GET
    Then status 200
    And match response.email == userEmail
    And match response.firstName == randomFirstName
    And match response.lastName == randomLastName

  Scenario: Get user by email - not found
    * def nonExistentEmail = faker.internet().emailAddress()
    Given path basePath, 'email', nonExistentEmail
    When method GET
    Then status 404

  Scenario: Update user successfully
    # Create user first
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userId = response.id

    # Generate new data for update
    * def updateEmail = faker.internet().emailAddress()
    * def updatePhone = '30' + faker.number().digits(8)
    * def updateUser =
      """
      {
        "email": "#(updateEmail)",
        "phone": "#(updatePhone)"
      }
      """

    # Update user
    Given path basePath, userId
    And request updateUser
    When method PUT
    Then status 200
    And match response.id == userId
    And match response.email == updateEmail
    And match response.phone == '#number'

    # Verify update persisted
    Given path basePath, userId
    When method GET
    Then status 200
    And match response.email == updateEmail