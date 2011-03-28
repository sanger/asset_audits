@sequencescape_service @admin @instruments
Feature: Manage instruments

  Scenario: View a list of existing Instruments
    Given I have an instrument "Big robot" with barcode "1234"
      And I have an instrument "Small robot" with barcode "5678"
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 0                   | 1234    |
      | Small robot | 0                   | 5678    |

  @create
  Scenario: Add an instrument
    Given I am on the instrument management page
    When I follow "New instrument"
    Then I should see "Name"
      And I should see "Barcode"
    When I fill in "Name" with "Big robot"
      And I fill in "Barcode" with "1234"
      And I press "Create instrument"
    Then I should see "Created instrument"
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 0                   | 1234    |
  
  @error @create
  Scenario Outline: Shouldnt be able to create an invalid instrument
    Given I am on the instrument management page
    When I follow "New instrument"
      And I fill in "Name" with "<name>"
      And I fill in "Barcode" with "<barcode>"
      And I press "Create instrument"
    Then I should see "Invalid inputs"
    Examples:
      | name | barcode |
      |      |         |
      | abc  |         |
      |      | 123     |
      
      
  @error @create
  Scenario Outline: Shouldnt be able to create a duplicate instrument
    Given I have an instrument "Big robot" with barcode "1234"
      And I am on the instrument management page
    When I follow "New instrument"
      And I fill in "Name" with "<name>"
      And I fill in "Barcode" with "<barcode>"
      And I press "Create instrument"
    Then I should see "Invalid inputs"
    Examples:
      | name           | barcode |
      | Big robot      | 9999    |
      | new robot name | 1234    |


  @delete
  Scenario: Delete an instrument
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has process "Cherrypick"
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 1                   | 1234    |
    When I follow "Delete Big robot"
    Then I should see "Deleted instrument"
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
    When I follow "Process index"
    Then the list of processes should look like:
      | Process      | Number of Instruments | Key           |
      | Cherrypick   | 0                     | cherrypicking |

  @edit
  Scenario: Edit an instrument
    Given I have an instrument "Big robot" with barcode "1234"
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 0                   | 1234    |
    When I follow "Edit Big robot"
    Then I should see "Name"
      And I should see "Barcode"
    When I fill in "Name" with "Medium robot"
      And I fill in "Barcode" with "9999"
      And I press "Update instrument"
    Then I should see "Updated instrument"
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument   | Number of Processes | Barcode |
      | Medium robot | 0                   | 9999    |

  @process
  Scenario: Add two processes to an instrument and view the index page
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have a process "Move plate" with key "move_plate"
    Given I have an instrument "Big robot" with barcode "1234"
      And I am on the instrument management page
    When I follow "Manage processes for Big robot"
    Then I should see "Add process"
    Then the instrument process table should be:
      | Process| Key | Witness? |
    When I select "Cherrypick" from "Process"
      And I press "Add process"
    Then I should see "Process added to instrument"
    Then the instrument process table should be:
      | Process    | Key           | Witness? |
      | Cherrypick | cherrypicking |          |
    When I select "Move plate" from "Process"
      And I press "Add process"
    Then I should see "Process added to instrument"
    Then the instrument process table should be:
      | Process    | Key           | Witness? |
      | Cherrypick | cherrypicking |          |
      | Move plate | move_plate    |          |
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 2                   | 1234    |

  @delete @process
  Scenario: Delete a process from an instrument
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has process "Cherrypick"
      And I am on the instrument management page
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 1                   | 1234    |
    When I follow "Manage processes for Big robot"
    Then the instrument process table should be:
      | Process    | Key           |
      | Cherrypick | cherrypicking |
    When I follow "Unlink Cherrypick"
    Then I should see "Removed process from instrument"
    Then the instrument process table should be:
      | Process    | Key           |
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 0                   | 1234    |

  @error @process
  Scenario: You shouldnt be able to add the same process twice to an instrument
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has process "Cherrypick"
      And I am on the instrument management page
    When I follow "Manage processes for Big robot"
    Then the instrument process table should be:
      | Process    | Key           |
      | Cherrypick | cherrypicking |
    When I select "Cherrypick" from "Process"
      And I press "Add process"
    Then I should see "Process already exists for instrument"
    Then the instrument process table should be:
      | Process    | Key           |
      | Cherrypick | cherrypicking |
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 1                   | 1234    |
    
    
  @witness @process
  Scenario: Add a process which needs to be witnessed
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have a process "Move plate" with key "move_plate"
    Given I have an instrument "Big robot" with barcode "1234"
      And I am on the instrument management page
    When I follow "Manage processes for Big robot"
    Then I should see "Add process"
    Then the instrument process table should be:
      | Process| Key | Witness? |
    When I select "Cherrypick" from "Process"
      And I check "Witness"
      And I press "Add process"
    Then I should see "Process added to instrument"
    Then the instrument process table should be:
      | Process    | Key           | Witness? |
      | Cherrypick | cherrypicking | Yes      |
    When I select "Move plate" from "Process"
      And I press "Add process"
    Then I should see "Process added to instrument"
    Then the instrument process table should be:
      | Process    | Key           | Witness? |
      | Cherrypick | cherrypicking | Yes      |
      | Move plate | move_plate    |          |
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 2                   | 1234    |
      