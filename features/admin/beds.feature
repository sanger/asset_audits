@sequencescape_service @admin @beds
Feature: Manage beds on an instrument

  @create
  Scenario: Add a bed to an instrument
    Given I have an instrument "Big robot" with barcode "1234"
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 0              |
    When I follow "Manage Big robot"
      And I fill in "Bed number" with "1"
      And I fill in "Bed name" with "SCRC1"
      And I fill in "Barcode" with "9999"
      And I press "Add bed"
    Then I should see "Bed created"
    Then the list of beds should look like:
      | Name  | Barcode | Number |
      | SCRC1 | 9999    | 1          |
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
      
  @delete
  Scenario: Delete a bed from an instrument
    Given I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has a bed with name "SCRC1" barcode "9999" and number 1
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
    When I follow "Manage Big robot"
    Then the list of beds should look like:
      | Name  | Barcode | Number |
      | SCRC1 | 9999    | 1          |
    When I follow "Delete bed 9999"
    Then the list of beds should look like:
      | Name  | Barcode | Number |
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 0              |
  
      
  Scenario: Duplicate barcodes are not allowed globally
    Given I have an instrument "Big robot" with barcode "1234"
      And I have an instrument "Small robot" with barcode "5678"
      And instrument "Big robot" has a bed with name "SCRC1" barcode "9999" and number 1
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
      | Small robot | 0              |
    When I follow "Manage Small robot"
      And I fill in "Bed number" with "1"
      And I fill in "Bed name" with "SCRC1"
      And I fill in "Barcode" with "9999"
      And I press "Add bed"
    Then I should see "Barcode must be unique"
    Given I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
      | Small robot | 0              |
  
  Scenario: Duplicate bed names are not allowed on the same instrument
    Given I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has a bed with name "SCRC1" barcode "9999" and number 1
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
    When I follow "Manage Big robot"
      And I fill in "Bed number" with "10"
      And I fill in "Bed name" with "SCRC1"
      And I fill in "Barcode" with "8888"
      And I press "Add bed"
    Then I should see "Name has already been taken"
    Given I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
  
  
  Scenario: Duplicate bed numbers are not allowed on the same instrument
    Given I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has a bed with name "SCRC1" barcode "9999" and number 1
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
    When I follow "Manage Big robot"
      And I fill in "Bed number" with "1"
      And I fill in "Bed name" with "SCRC2"
      And I fill in "Barcode" with "8888"
      And I press "Add bed"
    Then I should see "Bed number has already been taken"
    Given I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 1              |
      
      
  Scenario Outline: Only integers are allowed for bed numbers between 0 and 100
    Given I have an instrument "Big robot" with barcode "1234"
      And I am on the instrument management page
    When I follow "Manage Big robot"
      And I fill in "Bed number" with "<bed_number>"
      And I fill in "Bed name" with "SCRC2"
      And I fill in "Barcode" with "8888"
      And I press "Add bed"
    Then I should see "Bed number <error_message>"
    Given I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Beds |
      | Big robot   | 0              |
    Examples:
      | bed_number | error_message                  |
      |            | can only be whole numbers.     |
      | abc        | can only be whole numbers.     |
      | 1.0        | can only be whole numbers.     |
      | -1         | can only be between 0 and 100. |
      | 101        | can only be between 0 and 100. |
  