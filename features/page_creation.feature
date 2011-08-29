Feature: An admin can create a new Page
 
  Background:
    Given A "Test Site" has been instantiated
    And I am logged in as an admin
    And I am on the new page page
 
  Scenario: I can cancel as long as the payment is not claimed
    When I cancel my latest transaction
    Then I should see a cancellation confirmation
 
  Scenario: I can't cancel once the payment is claimed
    Given "Mukmuk" claimed the latest transaction
    Then I can't cancel my latest transaction
