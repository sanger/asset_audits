@sequencescape_service @user_barcode_service
Feature: Add an audit to an asset

  Scenario: All required information is scanned
    Given user "john" with barcode '2470000100730' exists
      And I have a "Tecan robot" instrument with barcode "abc123456"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
      And I have a plate with UUID "00000000-1111-2222-3333-444444444444" and barcode "1220094216791"
    Given I am on the new audit page
      
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | abc123456     |
      | Source plates      | 1220094216791 |
    When I select "Cherrypick" from "Instrument process"
      And I press "Submit"
      Then show me the page
    Then I should see "Added process"
      And I should be on the new audit page
  
  Scenario: Cant find user barcode
    Given I have a "Tecan robot" instrument with barcode "abc123"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
      And I have a plate with UUID "00000000-1111-2222-3333-444444444444" and barcode "1220094216791"
      
    Given I am on the new audit page
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | abc123        |
      | Source plates      | 1220094216791 |
    When I select "Cherrypick" from "Instrument process"
      And I press "Submit"
    Then I should see "Invalid user"
      And I should be on the new audit page
  
  Scenario: Cant find instrument barcode
    Given user "john" with barcode '2470000100730' exists
      And I have a "Tecan robot" instrument with barcode "9876"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
      And I have a plate with UUID "00000000-1111-2222-3333-444444444444" and barcode "1220094216791"
    
    Given I am on the new audit page
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | abc123        |
      | Source plates      | 1220094216791 |
    When I select "Cherrypick" from "Instrument process"
      And I press "Submit"
    Then I should see "Invalid instrument barcode"
      And I should be on the new audit page
  
  Scenario: Cant find plate barcodes
    Given user "john" with barcode '2470000100730' exists
      And I have a "Tecan robot" instrument with barcode "abc123"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
  
    Given I am on the new audit page
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | abc123        |
      | Source plates      | 9999999999999 |
    When I select "Cherrypick" from "Instrument process"
      And I press "Submit"
    Then I should see "Invalid plate barcodes"
      And I should be on the new audit page
  
  Scenario: Invalid process selected for an instrument
    Given user "john" with barcode '2470000100730' exists
      And I have a "Tecan robot" instrument with barcode "abc123"
      And I have a process "Cherrypick" as part of the "Tecan robot" instrument
      And I have a "Beckman" instrument with barcode "99999"
      And I have a process "Stamp for Sequenom" as part of the "Beckman" instrument
      And I have a plate with UUID "00000000-1111-2222-3333-444444444444" and barcode "1220094216791"
    
    Given I am on the new audit page
    When I fill in the following:
      | User barcode       | 2470000100730 |
      | Instrument barcode | abc123        |
      | Source plates      | 1220094216791 |
    When I select "Stamp for Sequenom" from "Instrument process"
      And I press "Submit"
    Then I should see "Invalid process for instrument"
      And I should be on the new audit page
  
  
  