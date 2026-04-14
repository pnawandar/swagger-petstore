Feature: Store order validation failures
  As a pet store API consumer
  I want invalid store orders to be rejected
  So that only valid orders are accepted by the API

  Background:
    Given the Petstore Store API is available

  Scenario: Reject order with missing required id
    Given I have an invalid order payload with:
      | petId    | 1001                 |
      | quantity | 1                    |
      | shipDate | 2026-04-14T10:00:00Z |
      | status   | placed               |
      | complete | false                |
    When I send a POST request to "/store/order"
    Then the response status code should be 400
    And the response body should describe a validation error

  Scenario: Reject order with negative quantity
    Given I have an invalid order payload with:
      | id       | 90002                |
      | petId    | 1001                 |
      | quantity | -5                   |
      | shipDate | 2026-04-14T10:00:00Z |
      | status   | placed               |
      | complete | false                |
    When I send a POST request to "/store/order"
    Then the response status code should be 400
    And the response body should describe a validation error

  Scenario: Reject order with non-numeric petId
    Given I have an invalid order payload with:
      | id       | 90003                |
      | petId    | abc                  |
      | quantity | 1                    |
      | shipDate | 2026-04-14T10:00:00Z |
      | status   | placed               |
      | complete | false                |
    When I send a POST request to "/store/order"
    Then the response status code should be 400
    And the response body should describe a validation error

  Scenario: Reject order with malformed shipDate
    Given I have an invalid order payload with:
      | id       | 90004      |
      | petId    | 1001       |
      | quantity | 1          |
      | shipDate | not-a-date |
      | status   | placed     |
      | complete | false      |
    When I send a POST request to "/store/order"
    Then the response status code should be 400
    And the response body should describe a validation error

  Scenario Outline: Reject order with unsupported status values
    Given I have an invalid order payload with:
      | id       | <id>                  |
      | petId    | 1001                  |
      | quantity | 1                     |
      | shipDate | 2026-04-14T10:00:00Z  |
      | status   | <status>              |
      | complete | false                 |
    When I send a POST request to "/store/order"
    Then the response status code should be 400
    And the response body should describe a validation error

    Examples:
      | id    | status     |
      | 90005 | cancelled  |
      | 90006 | processing |
      | 90007 | done       |
