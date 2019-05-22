@sequencescape_service @user_barcode_service @javascript @verification @sequenom_plate @audit_process
Feature: Verify assay plate positions on the robot

  Background:
    Given user "john" with barcode '2470000100730' exists
      And I have a "Liquid handling" instrument with barcode "abc123456"
      And the "Liquid handling" instrument has beds setup
      And I have a process "Sequenom" as part of the "Liquid handling" instrument with sequenom plate verification

   Scenario: A user accesses the disable feature
      Given I am on the new audit page
      When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      Then I should see "This process has been disabled."
      And I should be on the new audit page
