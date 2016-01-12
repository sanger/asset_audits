@sequencescape_service @user_barcode_service @audit_process @javascript @verification @dilution_plate
Feature: Verify location of plates

  Background:
    Given user "john" with barcode '2470000100730' exists
      And I have a "Liquid handling" instrument with barcode "abc123456"
      And the "Liquid handling" instrument has beds setup
      And I have a process "Working dilution" as part of the "Liquid handling" instrument with dilution plate verification

  Scenario: Valid plates and bed positions
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "456" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "123"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "777"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 194216
          }
      }
      """

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      And I select "Working dilution" from "Instrument process"
      And I wait 1 second
      And I fill in "Bed P2" with "2"
      And I fill in "Plate P2" with "123"
      And I fill in "Bed P3" with "3"
      And I fill in "Plate P3" with "456"
      And I press "Submit"
      And I wait 1 second
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails

  Scenario: Valid plates and bed positions where a witness is required
    Given user "jane" with barcode '2470041440697' exists
      And a process "Working dilution" as part of the "Liquid handling" instrument requires a witness
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "456" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "123"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "777"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 194216
          }
      }
      """

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      And I select "Working dilution" from "Instrument process"
      And I fill in "Bed P2" with "2"
      And I fill in "Plate P2" with "123"
      And I fill in "Bed P3" with "3"
      And I fill in "Plate P3" with "456"
      And I fill in "Witness barcode" with "2470041440697"
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails

