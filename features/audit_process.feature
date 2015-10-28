@sequencescape_service @user_barcode_service @audit_process
Feature: Add an audit to an asset
  @javascript
  Scenario: All required information is scanned
    Given user "john" with barcode '2470000100730' exists
      And I have a "Tecan robot" instrument with barcode "abc123456"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
    Given I am on the new audit page

    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      And I fill in "Source plates" with "1220094216791"
      And I select "Cherrypick" from "Instrument process"
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails

@javascript
  Scenario: Cant find instrument barcode
    Given user "john" with barcode '2470000100730' exists
      And I have a "Tecan robot" instrument with barcode "9876"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123"
      And I fill in "Source plates" with "1220094216791"
      And I select "Cherrypick" from "Instrument process"
      And I press "Submit"
    Then I should see "Invalid instrument or process"
      And I should be on the new audit page

  Scenario: Invalid process selected for an instrument
    Given user "john" with barcode '2470000100730' exists
      And I have a "Tecan robot" instrument with barcode "abc123"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
      And I have a "Beckman" instrument with barcode "99999"
      And I have a process "Stamp for Sequenom" as part of the "Beckman" instrument

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123"
      And I select "Stamp for Sequenom" from "Instrument process"
      #And I fill in "Source plates" with "1220094216791"
      And I press "Submit"
    Then I should see "Invalid instrument or process"
      And I should be on the new audit page




