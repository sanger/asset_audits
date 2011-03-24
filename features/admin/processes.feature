@sequencescape_service @admin @processes
Feature: Manage processes

  Scenario: View a list of existing Processes
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have a process "Volume Check" with key "volume_check"
      And I am on the process management page
    Then the list of processes should look like:
      | Process      | Number of Instruments | Key           |
      | Cherrypick   | 0                     | cherrypicking |
      | Volume Check | 0                     | volume_check  |
  
  @create
  Scenario: Add a new process
    Given I am on the process management page
    When I follow "New process"
    Then I should see "Name"
      And I should see "Key"
    When I fill in "Name" with "Volume Check"
      And I fill in "Key" with "volume_check"
      And I press "Create process"
    Then I should see "Created process"
    Then the list of processes should look like:
      | Process      | Key           |
      | Volume Check | volume_check  |
  
  @create @error
  Scenario Outline: Add an invalid process key
    Given I am on the process management page
    When I follow "New process"
    When I fill in "Name" with "Volume Check"
      And I fill in "Key" with "<key>"
      And I press "Create process"
    Then I should see "Invalid inputs"
    Examples: 
      | key     |
      | abc 123 |
      | +'=%    |
      |         |
  
  @create @error
  Scenario Outline: You shouldnt be able to add a process or key that already exists
    Given I have a process "Volume Check" with key "volume_check"
      And I am on the process management page
    When I follow "New process"
    When I fill in "Name" with "<name>"
      And I fill in "Key" with "<key>"
      And I press "Create process"
    Then I should see "Invalid inputs"
    Examples: 
      | name         | key          |
      | Volume Check | abc          |
      | abc          | volume_check |
  
  Scenario: Edit an existing process
    Given I have a process "Volume Check" with key "volume_check"
      And I am on the process management page
    Then the list of processes should look like:
      | Process      |  Key           |
      | Volume Check |  volume_check  |
    When I follow "Edit Volume Check"
      And I fill in "Name" with "Cherrypick"
      And I fill in "Key" with "abc"
      And I press "Update process"
    Then I should see "Updated process"
    Then the list of processes should look like:
      | Process    |  Key |
      | Cherrypick |  abc |

  Scenario: The number of instruments linked to a process should be displayed
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has process "Cherrypick"
      And I am on the process management page
    Then the list of processes should look like:
      | Process      | Number of Instruments | Key           |
      | Cherrypick   | 1                     | cherrypicking |
  
  Scenario: Delete a process and its link
    Given I have a process "Cherrypick" with key "cherrypicking"
      And I have an instrument "Big robot" with barcode "1234"
      And instrument "Big robot" has process "Cherrypick"
      And I am on the process management page
    Then the list of processes should look like:
      | Process      | Number of Instruments | Key           |
      | Cherrypick   | 1                     | cherrypicking |
    When I follow "Delete Cherrypick"
    Then I should see "Deleted process"
    When I follow "Instrument index"
    Then the list of instruments should look like:
      | Instrument  | Number of Processes | Barcode |
      | Big robot   | 0                   | 1234    |
  

