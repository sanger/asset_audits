@sequencescape_service @user_barcode_service @audit_process @javascript @verification @timecop
Feature: Verify destruction of plates

  Background:
    Given user "john" with barcode '2470000100730' exists
      And I have a "Plate destruction" instrument with barcode "abc123456"
      And I have a process "Destroy plates" as part of the "Plate destruction" instrument with destroy plates verification
      And all this is happening at "2015-05-05T13:45:00+01:00"

  Scenario Outline: Destroying various plates
    Given I can retrieve the labware with barcodes "<plate_1>, <plate_2>" and lifespans "<lifespan_1>, <lifespan_2>" and ages "<age_1>, <age_2>" and existence "<exists_1>, <exists_2>"

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Destroy plates" from AJAX dropdown "Instrument process"
      And I fill in "Source labware" with "<plate_1> <plate_2>"
      And I press "Submit"
      Then I should see "<message>"
      And I should be on the new audit page

    # The delayed job will raise an exception if it fails
    Examples:
      | plate_1                  | plate_2                  | lifespan_1 | lifespan_2 | age_1 | age_2 | exists_1 | exists_2 | valid  | message                                                                         |
      | old_plate                |                          |  30        |            | 35    |       | true     |          | notice | Success                                                                         |
      | old_plate                | other_old_plate          |  30        |  30        | 35    | 35    | true     | true     | notice | Success                                                                         |
      | old_plate                | fake_plate               |  30        |            | 35    |       | true     | false    | error  | The labware fake_plate hasn't been found                                        |
      | new_plate                |                          |  30        |            | 5     |       | true     |          | error  | The labware new_plate is less than 30 days old                                  |
      | old_plate                | new_plate                |  30        |  30        | 35    | 5     | true     | true     | error  | The labware new_plate is less than 30 days old                                  |
      | old_indestructable_plate |                          |  nil       |            | 35    |       | true     |          | error  | The labware old_indestructable_plate can't be destroyed because it's a immortal |
      | old_plate                | old_indestructable_plate |  30        |  nil       | 35    | 35    | true     | true     | error  | The labware old_indestructable_plate can't be destroyed because it's a immortal |


