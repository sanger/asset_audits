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
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "9999"
      And I select "Volume check" from "Instrument process"
      And I fill in "Source plates" with "1220094216791"
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed

  Scenario: A process requires a witness
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      And I select "Cherrypick" from AJAX dropdown "Instrument process"
      And I fill in "Source plates" with "1220094216791"
      And I fill in "Witness barcode" with "2470041440697"
      # And I press "Submit" # Not needed because above step hits 'enter' key and submits form
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed


  Scenario: Invalid user is scanned as the witness
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      And I select "Cherrypick" from "Instrument process"
      And I fill in "Source plates" with "1220094216791"
      And I fill in "Witness barcode" with "123456789"
      # And I press "Submit" # Not needed because above step hits 'enter' key and submits form
    Then I should see "Invalid witness barcode"
      And I should be on the new audit page

