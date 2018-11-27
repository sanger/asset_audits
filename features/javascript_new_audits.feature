@sequencescape_service @user_barcode_service @javascript @asset_audits @ajax_fields
Feature: Automatically populate the activity logging page when barcodes are scanned
  Background:
    Given I am on the new audit page


  Scenario: When I scan a valid user barcode the user name should be displayed
    Given user "john" with barcode '2470000100730' exists
    When I fill in "User barcode" with "2470000100730"
      And I should see "john" within "#user_barcode_results"

  Scenario: When I scan an invalid user barcode nothing should be displayed
    Given user "john" with barcode '2470000100730' exists
    When I fill in "User barcode" with "11111111111"
      And I should not see "john" within "#user_barcode_results"

  Scenario: Scanning a valid instrument barcode with no processes should list all processes and display instrument name
    Given I have a "Big robot" instrument with barcode "abc123456"
      And I have a "Another robot" instrument with barcode "xyz99"
      And I have a "Killer robot" instrument with barcode "987654321"
      And I have a process "Pico" as part of the "Another robot" instrument
      And I have a process "Gel" as part of the "Another robot" instrument
      And I have a process "Shake" as part of the "Killer robot" instrument

    When I fill in "Instrument barcode" with "abc123456"
    Then I wait 1 second
      And I should see "Big robot" within "#instrument_barcode_results"
    Then I wait 1 second
    When I select "Pico" from "Instrument process"
    Then I wait 1 second
      And I select "Shake" from "Instrument process"
    Then I wait 1 second
      And I select "Gel" from "Instrument process"
    Then I wait 1 second

  Scenario: Scanning a valid instrument barcode with linked process should list only that process
    Given I have a "Big robot" instrument with barcode "abc123456"
      And I have a "Another robot" instrument with barcode "xyz99"
      And I have a "Killer robot" instrument with barcode "987654321"
      And I have a process "Pico" as part of the "Another robot" instrument
      And I have a process "Gel" as part of the "Another robot" instrument
      And I have a process "Shake" as part of the "Killer robot" instrument

    When I fill in "Instrument barcode" with "xyz99"
    Then I wait 1 second
    When I select "Pico" from "Instrument process"
    Then I wait 1 second
      And I select "Gel" from "Instrument process"
    Then I wait 1 second
      And I should not see "Shake"

  Scenario: Scanning an invalid instrument barcode should populate the process list with all processes
    Given I have a "Big robot" instrument with barcode "abc123456"
      And I have a process "Pico" as part of the "Big robot" instrument
      And I have a process "Gel" as part of the "Big robot" instrument
      And I have a process "Shake" as part of the "Big robot" instrument

    When I fill in "Instrument barcode" with "xxxxxxxxx"
    Then I wait 1 second
    When I select "Pico" from "Instrument process"
    Then I wait 1 second
    And I select "Shake" from "Instrument process"
    Then I wait 1 second
    And I select "Gel" from "Instrument process"
    Then I wait 1 second

