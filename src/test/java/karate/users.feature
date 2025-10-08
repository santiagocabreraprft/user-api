
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

  Scenario: Update user successfully
    # Create user first
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userId = response.id
    * def userFirstName = response.firstName
    * def userLastName = response.lastName

    # Generate new data for update
    * def updateEmail = faker.internet().emailAddress()
    * def updatePhone = '30' + faker.number().digits(8)
    * def updateUser =
      """
      {
        "firstName": "#(userFirstName)",
        "lastName": "#(userLastName)",
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
    And match response.phone == '#string'

    # Verify update persisted
    Given path basePath, userId
    When method GET
    Then status 200
    And match response.email == updateEmail

  Scenario: Update user - not found
    * def updateEmail = faker.internet().emailAddress()
    * def updateUser =
      """
      {
        "firstName": faker.name().firstName(),
        "lastName": faker.name().lastName(),
        "email": "#(updateEmail)",
        "phone": "3008033642"
      }
      """
    Given path basePath, 99999
    And request updateUser
    When method PUT
    Then status 404

  Scenario: Delete user successfully
    # Create user first
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userId = response.id

    # Delete user
    Given path basePath, userId
    When method DELETE
    Then status 204

    # Verify user is deleted
    Given path basePath, userId
    When method GET
    Then status 404

  Scenario: Delete user - not found
    Given path basePath, 99999
    When method DELETE
    Then status 404

  Scenario: Create user with invalid email format
    * def invalidUser =
      """
      {
        "firstName": "#(faker.name().firstName())",
        "lastName": "#(faker.name().lastName())",
        "email": "invalid-email-format",
        "phone": "3046518850"
      }
      """
    Given path basePath
    And request invalidUser
    When method POST
    Then status 400

  Scenario: Create user with missing required fields
    * def incompleteUser =
      """
      {
        "firstName": "#(faker.name().firstName())"
      }
      """
    Given path basePath
    And request incompleteUser
    When method POST
    Then status 400

  Scenario: Create user with missing email
    * def userWithoutEmail =
      """
      {
        "firstName": "#(faker.name().firstName())",
        "lastName": "#(faker.name().lastName())",
        "phone": "3046518850"
      }
      """
    Given path basePath
    And request userWithoutEmail
    When method POST
    Then status 400

  Scenario: Create duplicate user - same email
    # Create first user
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userEmail = response.email

    # Try to create duplicate with same email
    * def duplicateUser =
      """
      {
        "firstName": "#(faker.name().firstName())",
        "lastName": "#(faker.name().lastName())",
        "email": "#(userEmail)",
        "phone": "3046518850"
      }
      """
    Given path basePath
    And request duplicateUser
    When method POST
    Then status 409

  Scenario: Update user with duplicate email
    # Create first user
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def firstUserEmail = response.email

    # Create second user
    * def secondUser =
      """
      {
        "firstName": "#(faker.name().firstName())",
        "lastName": "#(faker.name().lastName())",
        "email": "#(faker.internet().emailAddress())",
        "phone": "#('30' + faker.number().digits(8))"
      }
      """
    Given path basePath
    And request secondUser
    When method POST
    Then status 201
    * def secondUserId = response.id

    # Try to update second user with first user's email
    * def updateWithDuplicateEmail =
      """
      {
        "firstName": "#(faker.name().firstName())",
        "lastName": "#(faker.name().lastName())",
        "email": "#(firstUserEmail)",
        "phone": "3008033642"
      }
      """
    Given path basePath, secondUserId
    And request updateWithDuplicateEmail
    When method PUT
    Then status 409

#  Scenario: Create multiple users and verify list
#    # Create first user
#    * def user1 =
#      """
#      {
#        "firstName": "#(faker.name().firstName())",
#        "lastName": "#(faker.name().lastName())",
#        "email": "#(faker.internet().emailAddress())",
#        "phone": "#('30' + faker.number().digits(8))"
#      }
#      """
#    Given path basePath
#    And request user1
#    When method POST
#    Then status 201
#    * def userId1 = response.id
#
#    # Create second user
#    * def user2 =
#      """
#      {
#        "firstName": "#(faker.name().firstName())",
#        "lastName": "#(faker.name().lastName())",
#        "email": "#(faker.internet().emailAddress())",
#        "phone": "#('30' + faker.number().digits(8))"
#      }
#      """
#    Given path basePath
#    And request user2
#    When method POST
#    Then status 201
#    * def userId2 = response.id
#
#    # Verify both users in list
#    Given path basePath
#    When method GET
#    Then status 200
#    And match response == '#[]'
#    And match response[*].id contains [userId1, userId2]

  Scenario: Complete CRUD workflow with random data
    # 1. Create user
    Given path basePath
    And request testUser
    When method POST
    Then status 201
    * def userId = response.id
    * def originalEmail = response.email
    * print 'Created user with ID:', userId

    # 2. Read user by ID
    Given path basePath, userId
    When method GET
    Then status 200
    And match response.email == originalEmail

    # 3. Update user
    * def newEmail = faker.internet().emailAddress()
    * def newPhone = '30' + faker.number().digits(8)
    * def updateData =
      """
      {
        "firstName": "#(response.firstName)",
        "lastName": "#(response.lastName)",
        "email": "#(newEmail)",
        "phone": "#(newPhone)"
      }
      """
    Given path basePath, userId
    And request updateData
    When method PUT
    Then status 200
    And match response.email == newEmail

    # 4. Verify update by getting user
    Given path basePath, userId
    When method GET
    Then status 200
    And match response.email == newEmail

    # 5. Delete user
    Given path basePath, userId
    When method DELETE
    Then status 204

    # 6. Verify user is deleted
    Given path basePath, userId
    When method GET
    Then status 404