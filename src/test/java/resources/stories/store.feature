Feature: Store order management
  As a pet store API consumer
  I want to manage store orders
  So that inventory and order lifecycle are handled correctly

  Background:
    Given the Petstore Store API is available

  Scenario: Retrieve store inventory successfully
    When I send a GET request to "/store/inventory"
    Then the response status code should be 200
    And the response body should be a JSON object
    And the response should contain inventory counts by pet status

  Scenario: Place a new order successfully
    Given I have a valid order payload with:
      | id       | 90001                |
      | petId    | 1001                 |
      | quantity | 2                    |
      | shipDate | 2026-04-14T10:00:00Z |
      | status   | placed               |
      | complete | false                |
    When I send a POST request to "/store/order"
    Then the response status code should be 200
    And the response body field "id" should be 90001
    And the response body field "status" should be "placed"

  Scenario: Retrieve an existing order by id
    Given an order exists with id 90001
    When I send a GET request to "/store/order/90001"
    Then the response status code should be 200
    And the response body field "id" should be 90001
    And the response body field "petId" should be 1001

  Scenario: Delete an existing order
    Given an order exists with id 90001
    When I send a DELETE request to "/store/order/90001"
    Then the response status code should be 200
    When I send a GET request to "/store/order/90001"
    Then the response status code should be 404

  Scenario Outline: Validate invalid order id retrieval
    When I send a GET request to "/store/order/<orderId>"
    Then the response status code should be <statusCode>

    Examples:
      | orderId | statusCode |
      | -1      | 400        |
      | abc     | 400        |
      | 999999  | 404        |
