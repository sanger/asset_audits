@sequencescape_service @user_barcode_service @javascript @audit_process @verification @assay_plate
Feature: Verify assay plate positions on the robot

  Background:
    Given user "john" with barcode '2470000100730' exists
      And I have a "Liquid handling" instrument with barcode "abc123456"
      And the "Liquid handling" instrument has beds setup

  Scenario Outline: Valid plates and bed positions
    Given I have a process "Assay Plate creation" as part of the "Liquid handling" instrument with "<bed_type>" assay plate verification
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "source1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "another_source"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest2" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "source1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "another_source2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      And I select "Assay Plate creation" from AJAX dropdown "Instrument process"
      And I fill in "Bed P<source_1_bed>" with "<source_1_bed>"
      And I fill in "Plate P<source_1_bed>" with "source1"
      And I fill in "Bed P<dest_1_bed>" with "<dest_1_bed>"
      And I fill in "Plate P<dest_1_bed>" with "dest1"
      And I fill in "Bed P<dest_2_bed>" with "<dest_2_bed>"
      And I fill in "Plate P<dest_2_bed>" with "dest2"
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails
    Examples:
      | bed_type | source_1_bed | dest_1_bed | dest_2_bed |
      | Nx       | 4            | 5          | 6          |
      | Fx       | 6            | 7          | 8          |

  Scenario Outline: Valid plates and bed positions where a witness is required
    Given I have a process "Assay Plate creation" as part of the "Liquid handling" instrument with "<bed_type>" assay plate verification
    Given user "jane" with barcode '2470041440697' exists
      And a process "Assay Plate creation" as part of the "Liquid handling" instrument requires a witness
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "source1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "another_source"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest2" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "source1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "another_source2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      #And I fill in "Instrument barcode" with "abc123456"
      And I fill in "Instrument barcode" with "abc123456"
      And I select "Assay Plate creation" from AJAX dropdown "Instrument process"
      And I wait 1 second
      And I fill in "Bed P<source_1_bed>" with "<source_1_bed>"
      And I fill in "Plate P<source_1_bed>" with "source1"
      And I fill in "Bed P<dest_1_bed>" with "<dest_1_bed>"
      And I fill in "Plate P<dest_1_bed>" with "dest1"
      And I fill in "Bed P<dest_2_bed>" with "<dest_2_bed>"
      And I fill in "Plate P<dest_2_bed>" with "dest2"
      And I fill in "Witness barcode" with "2470041440697"
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails
    Examples:
      | bed_type | source_1_bed | dest_1_bed | dest_2_bed |
      | Nx       | 4            | 5          | 6          |
      | Fx       | 6            | 7          | 8          |

  Scenario Outline: Barcodes scanned incorrectly on NX
    Given I have a process "Assay Plate creation" as part of the "Liquid handling" instrument with "Nx" assay plate verification
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "source1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "another_source"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest2" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "source1"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "another_source2"
              }
          }],
          "uuids_to_ids": {
              "00000000-1111-2222-3333-444444444444": 1
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "xxx" returns the following JSON:
      """
      {
          "searches": [],
          "uuids_to_ids": {
          }
      }
      """

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in "Instrument barcode" with "abc123456"
      And I select "Assay Plate creation" from AJAX dropdown "Instrument process"
      And I wait 1 second
      And I fill in "Bed P4" with "<source_bed>"
      And I fill in "Plate P4" with "<source_plate>"
      And I fill in "Bed P5" with "<destination_1_bed>"
      And I fill in "Plate P5" with "<destination_1_plate>"
      And I fill in "Bed P6" with "<destination_2_bed>"
      And I fill in "Plate P6" with "<destination_2_plate>"
      And I press "Submit"
      And I wait 1 second
    Then I should see "<error_message>"
    Examples:
      | source_bed | source_plate | destination_1_bed | destination_1_plate | destination_2_bed | destination_2_plate | error_message                          |
      |            | source1      | 5                 | dest1               | 6                 | dest2               | Invalid layout                         |
      | 4          |              | 5                 | dest1               | 6                 | dest2               | No plates scanned                      |
      | 4          | source1      |                   | dest1               | 6                 | dest2               | Invalid layout                         |
      | 4          | source1      | 5                 |                     | 6                 | dest2               | Invalid layout                         |
      | 4          | source1      | 5                 | dest1               |                   | dest2               | Invalid layout                         |
      | 4          | source1      | 5                 | dest1               | 6                 |                     | Invalid layout                         |
      |            |              | 5                 | dest1               | 6                 | dest2               | No plates scanned                      |
      | source1    | 4            | 5                 | dest1               | 6                 | dest2               | Invalid layout                         |
      | 4          | source1      | dest1             | dest1               | 6                 | dest2               | Invalid layout                         |
      | 5          | source1      | 5                 | dest1               | 6                 | dest2               | Invalid layout                         |
      | 4          | source1      | 4                 | dest1               | 6                 | dest2               | Invalid layout                         |
      | 4          | source1      | 5                 | dest1               | 4                 | dest2               | Invalid layout                         |
      | 4          | dest1        | 5                 | dest1               | 6                 | dest2               | Invalid source plate layout            |
      | 4          | dest2        | 5                 | dest1               | 6                 | source1             | Invalid source plate layout            |
      | xx         | source1      | 5                 | dest1               | 6                 | dest2               | Invalid layout                         |
      | 4          | source1      | xx                | dest1               | 6                 | dest2               | Invalid layout                         |
      | 4          | xxx          | 5                 | dest1               | 6                 | dest2               | Invalid source plate layout            |
      | 4          | source1      | 5                 | xxx                 | 6                 | dest2               | Invalid source plate layout            |
      | 4          | source1      | 5                 | dest1               | 6                 | xxx                 | Invalid source plate layout            |
      | 4          | source1      | 5                 | dest1               | xxx               | dest2               | Invalid layout                         |
      | 4          | source1      |                   |                     | 6                 | dest2               | All destination plates must be scanned |
      | 4          | source1      | 5                 | dest1               |                   |                     | All destination plates must be scanned |


