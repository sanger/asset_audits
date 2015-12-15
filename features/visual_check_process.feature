@sequencescape_service @user_barcode_service @audit_process @javascript
Feature: Require a visual check for a process

  Background:
    Given user "john" with barcode '2470000100730' exists
      And user "jane" with barcode '2470041440697' exists
      And I have a "Tecan robot" instrument with barcode "abc123456"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
      And I have a process "Pico dilution" as part of the "Tecan robot" instrument
      And a process "Pico dilution" requires visual check
      And a process "Cherrypick" does not require visual check
    Given I am on the new audit page

  Scenario: Only show the visual check box if its required
    Given I select "Cherrypick" from "Instrument process"
    Then I should not display "visual_check_input"

    Given I select "Pico dilution" from "Instrument process"
    Then I should display "visual_check_input"

  Scenario: Create plates with a visual check required attribute depending on input
    Given I am on the new audit page
    Given I fill in "User barcode" with "2470000100730"
    And I fill in "Instrument barcode" with "abc123456"
    Then I wait 1 second
    And I select "Pico dilution" from "Instrument process"
    And I check "visual_check"
    And I should have 0 plates
    When I press "Submit"

    Then I should see "Success"
    And I should be on the new audit page
    And I should have 1 plates
    And I should have performed visual check on the last plate

    Given I am on the new audit page
    Given I fill in "User barcode" with "2470000100730"
    And I fill in "Instrument barcode" with "abc123456"
    Then I wait 1 second
    And I select "Pico dilution" from "Instrument process"
    And I check "visual_check"
    And I should have 1 plates
    When I press "Submit"

    Then I should see "Success"
    And I should be on the new audit page
    And I should have 2 plates
    And I should have performed visual check on the last plate

  Scenario: Avoid creating a plate if the instrument requires visual check and has not been performed
    Given I am on the new audit page
    Given I fill in "User barcode" with "2470000100730"
    And I fill in "Instrument barcode" with "abc123456"
    Then I wait 1 second
    Given I select "Pico dilution" from "Instrument process"
    And I uncheck "Visual check performed"
    And I should have 0 plates
    When I press "Submit"

    Then I should see "Visual check required for this type"
    And I should be on the new audit page
    And I should have 0 plates

