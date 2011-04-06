@sequencescape_service @user_barcode_service @audit_process @witness @javascript
Feature: Require a witness for a process

  Background:
    Given user "john" with barcode '2470000100730' exists
      And user "jane" with barcode '2470041440697' exists
      And I have a "Tecan robot" instrument with barcode "abc123456"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument which requires a witness
    Given I am on the new audit page

  Scenario: Only show the witness box if its required
    Given I have a "Big robot" instrument with barcode "9999"
    And I have a process "Volume check" as part of the "Big robot" instrument
    Given I am on the new audit page
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | 9999          |
      | Source plates      | 1220094216791 |
    When I select "Volume check" from "Instrument process"
    When I press "Submit"
    Then I should see "Added process"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    
    
  Scenario: A process requires a witness
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | abc123456     |
      | Source plates      | 1220094216791 |
    When I select "Cherrypick" from AJAX dropdown "Instrument process"    
    When I fill in "Witness barcode" with "2470041440697"
      And I press "Submit"
    Then I should see "Added process"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
  
  
  Scenario Outline: Invalid user is scanned as the witness
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | abc123456     |
      | Source plates      | 1220094216791 |
    When I select "Cherrypick" from AJAX dropdown "Instrument process"    
    When I fill in "Witness barcode" with "<witness>"
      And I press "Submit"
    Then I should see "Invalid witness barcode"
      And I should be on the new audit page
    Examples:
      | witness       |
      | 2470000100730 |
      |               |
      | abc           |
      | 123456789     |
      