@sequencescape_service @user_barcode_service @javascript @verification @assay_plate @audit_process
Feature: Verify group assay plates positions on the robot

  Background:
    Given user "john" with barcode '2470000100730' exists
      And I have a "Some stuff" instrument with barcode "abc123456"
      And the "Some stuff" instrument has beds setup

    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "wd1" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "stock1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "stock2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "wd2" returns the following JSON:
      """
      {
          "searches": [
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "stock2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "wd3" returns the following JSON:
      """
      {
          "searches": [
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "stock2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "wd4" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "stock4"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """

    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "pico1" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "wd1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "wd2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "pico2" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "wd1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "wd2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "pico4" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "wd4"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """

    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "pico5" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "wd4"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """

    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "stock2" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "plate1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "plate2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "stock3" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "plate1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "plate2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """

  Scenario Outline: Valid plates and bed positions
    Given I have a process "Some process" as part of the "Some stuff" instrument with x2 dilution assay nx bed verification
    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Some process" from AJAX dropdown "Instrument process"


      And I fill in "Bed P2" with "<source_1_bed>"
      And I fill in "Plate P2" with "<plate_1>"
      And I fill in "Bed P3" with "<dest_1_bed>"
      And I fill in "Plate P3" with "<plate_2>"
      And I fill in "Bed P5" with "<dest_2_bed>"
      And I fill in "Plate P5" with "<plate_3>"
      And I fill in "Bed P6" with "<dest_3_bed>"
      And I fill in "Plate P6" with "<plate_4>"
      And I press "Submit"

    Then I should see "<result>"
      And I should be on the new audit page
    # The delayed job will raise an exception if it fails
    Examples:
      | source_1_bed | dest_1_bed | dest_2_bed | dest_3_bed | plate_1 | plate_2 | plate_3 | plate_4 | result                           |
      | 2            | 3          | 5          | 6          | stock1  | wd1     | pico1   | pico2   | Success                          |
      | 2            | 3          | 5          | 7          | stock1  | wd1     | pico1   | pico2   | Invalid layout                   |
      | 2            | 3          | 5          | 6          | stock1  | pico1   | pico2   | pico1   | Invalid source plate layout      |
      | 2            | 3          | 5          | 6          | stock1  | wd1     | stock2  | pico2   | Invalid source plate layout      |
      | 2            | 3          | 5          | 6          | wd1     | pico1   | pico2   | stock1  | Invalid source plate layout      |
      | 2            | 3          | 5          | 6          | stock2  | wd1     | pico2   | pico1   | Success                          |
      | 2            | 3          | 5          | 6          | stock3  | wd1     | pico2   | pico1   | Invalid source plate layout      |
      | 2            | 3          | 5          | 6          | stock1  | wd1     | pico2   | pico1   | Success                          |
      | 2            | 3          | 5          | 6          | plate1  | stock2  | wd1     | wd2     | Success                          |
      | 2            | 3          | 5          | 6          | stock2  | wd1     | wd2     | wd3     | Invalid source plate layout      |
      | 2            | 3          | 5          | 6          |         | wd1     | pico2   | pico1   | Invalid layout                   |
      | 2            | 3          | 5          | 6          | stock1  |         | pico2   | pico1   | Invalid layout                   |
      | 2            | 3          | 5          | 6          |         |         | pico1   | pico2   | Invalid layout                   |
      | 2            | 3          | 5          | 6          | stock1  |         | pico2   | pico1   | Invalid layout                   |
      | 2            | 3          | 5          |            | stock1  | wd1     | pico1   |         | Invalid destination plate layout |

  Scenario Outline: Valid plates and bed positions for 2x assay bed verification
    Given I have a process "Some process" as part of the "Some stuff" instrument with x2 dilution assay nx bed verification
    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Some process" from AJAX dropdown "Instrument process"


      And I fill in "Bed P2" with "2" if "<plate_1>" not empty
      And I fill in "Plate P2" with "<plate_1>" if not empty
      And I fill in "Bed P3" with "3" if "<plate_2>" not empty
      And I fill in "Plate P3" with "<plate_2>" if not empty
      And I fill in "Bed P5" with "5" if "<plate_3>" not empty
      And I fill in "Plate P5" with "<plate_3>" if not empty
      And I fill in "Bed P6" with "6" if "<plate_4>" not empty
      And I fill in "Plate P6" with "<plate_4>" if not empty
      And I fill in "Bed P8" with "8" if "<plate_5>" not empty
      And I fill in "Plate P8" with "<plate_5>" if not empty
      And I fill in "Bed P9" with "9" if "<plate_6>" not empty
      And I fill in "Plate P9" with "<plate_6>" if not empty
      And I fill in "Bed P11" with "11" if "<plate_7>" not empty
      And I fill in "Plate P11" with "<plate_7>" if not empty
      And I fill in "Bed P12" with "12" if "<plate_8>" not empty
      And I fill in "Plate P12" with "<plate_8>" if not empty

      And I press "Submit"

    Then I should see "<result>"
      And I should be on the new audit page
    # The delayed job will raise an exception if it fails
    Examples:
      | plate_1 | plate_2 | plate_3 | plate_4 | plate_5 | plate_6 | plate_7    | plate_8  | result  | comment            |
      | stock1  | wd1     | pico1   | pico2   |         |         |            |          | Success | First group        |
      | stock1  | wd1     | pico1   | pico2   | stock1  | wd1     | pico1      | pico2    | Success |                    |
      |         | wd1     | pico1   | pico2   |         | wd1     | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock1  | pico1   | pico2      | pico1    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock1  | wd1     | stock2     | pico2    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | wd1     | pico1   | pico2      | stock1   | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  | wd1     | pico2      | pico1    | Success |                    |
      | stock1  | wd1     | pico1   | pico2   | stock3  | wd1     | pico2      | pico1    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock1  | wd1     | pico2      | pico1    | Success |                    |
      | stock1  | wd1     | pico1   | pico2   | plate1  | stock2  | wd1        | wd2      | Success |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  | wd1     | wd2        | wd3      | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   |         | wd1     | pico2      | pico1    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock1  |         | pico2      | pico1    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   |         |         | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock1  |         | pico2      | pico1    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  |         |            |          | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  | wd1     |            |          | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  | wd1     | pico1      |          | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  |         | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  | wd1     |            | pico2    | Invalid |                    |
      | stock1  |         | pico1   | pico2   | stock2  | wd1     | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     |         | pico2   | stock2  | wd1     | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     | pico1   |         | stock2  | wd1     | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     |         |         | stock2  | wd1     | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock4  | wd4     | pico4      | pico5    | Success |                    |
      | stock1  | wd1     | pico1   | pico2   | stock4  | wd1     | pico1      | pico2    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock4  | wd4     | pico1      | pico5    | Invalid |                    |
      | stock1  | wd1     | pico1   | pico2   | stock2  | wd1     | pico1      | pico2    | Success | This is impossible |
      | stock1  | wd1     | pico1   | pico2   |         | wd1     | pico1      | pico2    | Invalid |                    |
      |         | wd1     | pico1   | pico2   | stock2  | wd1     | pico1      | pico2    | Invalid |                    |
      |         | wd1     | pico1   | pico2   |         | wd1     | pico1      | pico2    | Invalid |                    |
