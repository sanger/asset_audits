@sequencescape_service @user_barcode_service @audit_process @javascript @verification
Feature: Verify location of plates

  Background:
    Given user "john" with barcode '2470000100730' exists

  Scenario: Valid plates and bed positions
    Given I have a "Liquid handling" instrument with barcode "abc123456"
      And the "Liquid handling" instrument has beds setup
      And I have a process "Working dilution" as part of the "Liquid handling" instrument with dilution plate verification
    Given search with UUID "00000000-0000-0000-0000-000000000002" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "ean13_barcode": "123"
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "ean13_barcode": "777"
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 194216
          }
      }
      """
    
    Given I am on the new audit page  
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Working dilution" from AJAX dropdown "Instrument process"
    When I fill in the following:
      | Bed P2   | 2   |
      | Plate P2 | 123 |
      | Bed P3   | 3   |
      | Plate P3 | 456 |
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails
    
  Scenario Outline: Barcodes scanned incorrectly
    Given I have a "Liquid handling" instrument with barcode "abc123456"
      And the "Liquid handling" instrument has beds setup
      And I have a process "Working dilution" as part of the "Liquid handling" instrument with dilution plate verification
    Given search with UUID "00000000-0000-0000-0000-000000000002" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "ean13_barcode": "123"
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "ean13_barcode": "777"
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 194216
          }
      }
      """
  
    Given I am on the new audit page  
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Working dilution" from AJAX dropdown "Instrument process"
    When I fill in the following:
      | Bed P2   | <source_bed>        |
      | Plate P2 | <source_plate>      |
      | Bed P3   | <destination_bed>   |
      | Plate P3 | <destination_plate> |
      And I press "Submit"
    Then I should see "<error_message>"
    Examples:
      | source_bed | source_plate | destination_bed | destination_plate | error_message                    |
      | 3          | 123          | 2               | 456               | Invalid layout                   |
      | 2          | 456          | 3               | 123               | Invalid source plate layout      |
      | 3          | 456          | 2               | 123               | Invalid layout                   |
      |            |              |                 |                   | No plates scanned                |
      | 2          |              |                 |                   | No plates scanned                |
      | 2          | 123          |                 |                   | Invalid destination plate layout |
      | 2          | 123          | 3               |                   | Invalid layout                   |
      | 2          | 123          |                 | 456               | Invalid layout                   |
      |            | 123          | 3               | 456               | Invalid layout                   |
      |            |              | 3               | 456               | Invalid source plate layout      |
      |            |              |                 | 456               | Invalid layout                   |
      | 2          |              | 3               |                   | No plates scanned                |
      |            | 123          |                 | 456               | Invalid layout                   |
      | 2          | 999          | 3               | 888               | Invalid source plate layout       |


  
  Scenario: Witness required and provided
  
  Scenario: Witness required and not provided
