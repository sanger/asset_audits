@sequencescape_service @user_barcode_service @audit_process @javascript @verification @timecop
Feature: Verify destruction of plates

  Background:
    Given user "john" with barcode '2470000100730' exists
      And I have a "Plate destruction" instrument with barcode "abc123456"
      And I have a process "Destroy plates" as part of the "Plate destruction" instrument with destroy plates verification
      And all this is happening at "2015-05-05T13:45:00+01:00"

  Scenario Outline: Destroying various plates
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcodes "<plate_1>, <plate_2>" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "old_plate",
                "machine": "old_plate"
              },
              "plate_purpose": { "lifespan":30, "uuid":"00000000-2222-2222-3333-444444444444" },
              "created_at":"2015-01-01T13:45:00+01:00"
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "new_plate",
                "machine": "new_plate"
              },
              "plate_purpose": {"lifespan":30, "uuid":"00000000-2222-2222-3333-444444444444" },
              "created_at":"2015-05-01T13:45:00+01:00"
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "old_indestructable_plate",
                "machine": "old_indestructable_plate"
              },
              "plate_purpose": { "lifespan":null, "name":"immortal", "uuid":"00000000-2222-2222-3333-444444444446"  },
              "created_at":"2015-01-01T13:45:00+01:00"
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444447",
              "barcode": {
                "ean13": "other_old_plate",
                "machine": "other_old_plate"
              },
              "plate_purpose": {"lifespan":30, "uuid":"00000000-2222-2222-3333-444444444444" },
              "created_at":"2015-01-01T13:45:00+01:00"
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 194216,
              "00000000-1111-2222-3333-444444444445": 194217,
              "00000000-1111-2222-3333-444444444446": 194218,
              "00000000-1111-2222-3333-444444444447": 194219
          }
      }
      """

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Destroy plates" from AJAX dropdown "Instrument process"
      And I fill in "Source plates" with "<plate_1> <plate_2>"
      And I press "Submit"
      Then I should see "<message>"
      And I should be on the new audit page

    # The delayed job will raise an exception if it fails
    Examples:
      | plate_1                  | plate_2                  | valid  | message                                                                       |
      | old_plate                |                          | notice | Success                                                                       |
      | old_plate                | other_old_plate          | notice | Success                                                                       |
      | old_plate                | fake_plate               | error  | The plate fake_plate hasn't been found                                        |
      | new_plate                |                          | error  | The plate new_plate is less than 30 days old                                  |
      | old_plate                | new_plate                | error  | The plate new_plate is less than 30 days old                                  |
      | old_indestructable_plate |                          | error  | The plate old_indestructable_plate can't be destroyed because it's a immortal |
      | old_plate                | old_indestructable_plate | error  | The plate old_indestructable_plate can't be destroyed because it's a immortal |


