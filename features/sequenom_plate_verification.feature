@sequencescape_service @user_barcode_service @javascript @verification @sequenom_plate
Feature: Verify assay plate positions on the robot

  Background:
    Given user "john" with barcode '2470000100730' exists
      And I have a "Liquid handling" instrument with barcode "abc123456"
      And the "Liquid handling" instrument has beds setup
      And I have a process "Sequenom" as part of the "Liquid handling" instrument with sequenom plate verification
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "6250000001741"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "6250000002755"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "6250000003769"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444447",
              "barcode": {
                "ean13": "6250000004773"
              }
          }],
          "uuids_to_ids": {
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest2" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "6250000001741"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "6250000002755"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "6250000003769"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444447",
              "barcode": {
                "ean13": "6250000004773"
              }
          }],
          "uuids_to_ids": {
          }
      }
      """

    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest3" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "6250000001741"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "6250000002755"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "6250000003769"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444447",
              "barcode": {
                "ean13": "6250000004773"
              }
          }],
          "uuids_to_ids": {
          }
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000002" for barcode "dest4" returns the following JSON:
      """
      {
          "searches": [{
              "uuid": "00000000-1111-2222-3333-444444444444",
              "barcode": {
                "ean13": "6250000001741"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444445",
              "barcode": {
                "ean13": "6250000002755"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444446",
              "barcode": {
                "ean13": "6250000003769"
              }
          },
          {
              "uuid": "00000000-1111-2222-3333-444444444447",
              "barcode": {
                "ean13": "6250000004773"
              }
          }],
          "uuids_to_ids": {
          }
      }
      """

  Scenario Outline: Valid setup for creating a sequenom plate with varying numbers of plates
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": 384
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest2" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": 384
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest3" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": 384
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest4" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": 384
          }]
      }
      """

    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Sequenom" from AJAX dropdown "Instrument process"
      And I fill in "Bed P2" with "<bed_p2>"
      And I fill in "Plate P2" with "<source_1>"
      And I fill in "Bed P5" with "<bed_p5>"
      And I fill in "Plate P5" with "<source_2>"
      And I fill in "Bed P8" with "<bed_p8>"
      And I fill in "Plate P8" with "<source_3>"
      And I fill in "Bed P11" with "<bed_p11>"
      And I fill in "Plate P11" with "<source_4>"
      And I fill in "Bed P3" with "<bed_p3>"
      And I fill in "Plate P3" with "<destination_1>"
      And I fill in "Bed P6" with "<bed_p6>"
      And I fill in "Plate P6" with "<destination_2>"
      And I fill in "Bed P9" with "<bed_p9>"
      And I fill in "Plate P9" with "<destination_3>"
      And I fill in "Bed P12" with "<bed_p12>"
      And I fill in "Plate P12" with "<destination_4>"
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails
    Examples:
      | source_1      | source_2      | source_3      | source_4      | destination_1 | destination_2 | destination_3 | destination_4 | destination_plate_name      | bed_p2 | bed_p5 | bed_p8 | bed_p11 | bed_p3 | bed_p6 | bed_p9 | bed_p12 |
      | 6250000001741 |               |               |               | dest1         |               |               |               | QC1____20101110             | 2      |        |        |         | 3      |        |        |         |
      | 6250000001741 | 6250000002755 |               |               | dest1         |               |               |               | QC1_2___20101110            | 2      | 5      |        |         | 3      |        |        |         |
      | 6250000001741 | 6250000002755 | 6250000003769 |               | dest1         |               |               |               | QC1_2_3__20101110           | 2      | 5      | 8      |         | 3      |        |        |         |
      | 6250000001741 | 6250000002755 | 6250000003769 | 6250000004773 | dest1         |               |               |               | QC1_2_3_4_20101110          | 2      | 5      | 8      | 11      | 3      |        |        |         |
      | 6250000001741 | 6250000002755 | 6250000003769 | 6250000004773 | dest1         | dest2         |               |               | QC1_2_3_4_20101110          | 2      | 5      | 8      | 11      | 3      | 6      |        |         |
      | 6250000001741 | 6250000002755 |               |               | dest3         | dest1         | dest2         |               | QC1_2___20101110            | 2      | 5      |        |         | 3      | 6      | 9      |         |
      | 6250000001741 | 6250000002755 | 6250000003769 | 6250000004773 | dest1         | dest2         | dest3         |               | QC1_2_3_4_20101110          | 2      | 5      | 8      | 11      | 3      | 6      | 9      |         |
      | 6250000001741 |               |               |               | dest1         | dest2         | dest3         | dest4         | Replication1____20101110    | 2      |        |        |         | 3      | 6      | 9      | 12      |
      | 6250000001741 | 6250000002755 |               |               | dest1         | dest2         | dest3         | dest4         | Replication1_2___20101110   | 2      | 5      |        |         | 3      | 6      | 9      | 12      |
      | 6250000001741 | 6250000002755 | 6250000003769 |               | dest4         | dest3         | dest2         | dest1         | Replication1_2_3__20101110  | 2      | 5      | 8      |         | 3      | 6      | 9      | 12      |
      | 6250000001741 | 6250000002755 | 6250000003769 | 6250000004773 | dest1         | dest2         | dest3         | dest4         | Replication1_2_3_4_20101110 | 2      | 5      | 8      | 11      | 3      | 6      | 9      | 12      |



  Scenario: Requires a witness
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "name": "QC1_2_3_4_20101110",
              "size": 384
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest2" returns the following JSON:
      """
      {
          "searches": [{
              "name": "QC1_2_3_4_20101110",
              "size": 384
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest3" returns the following JSON:
      """
      {
          "searches": [{
              "name": "QC1_2_3_4_20101110",
              "size": 384
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest4" returns the following JSON:
      """
      {
          "searches": [{
              "name": "QC1_2_3_4_20101110",
              "size": 384
          }]
      }
      """
    Given user "jane" with barcode '2470041440697' exists
      And a process "Sequenom" as part of the "Liquid handling" instrument requires a witness
      And I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Sequenom" from AJAX dropdown "Instrument process"
      And I fill in "Bed P2" with "2"
      And I fill in "Plate P2" with "6250000001741"
      And I fill in "Bed P5" with "5"
      And I fill in "Plate P5" with "6250000002755"
      And I fill in "Bed P8" with "8"
      And I fill in "Plate P8" with "6250000003769"
      And I fill in "Bed P11" with "11"
      And I fill in "Plate P11" with "6250000004773"
      And I fill in "Bed P3" with "3"
      And I fill in "Plate P3" with "dest1"
      And I fill in "Bed P6" with "6"
      And I fill in "Plate P6" with "dest2"
      And I fill in "Bed P9" with "9"
      And I fill in "Plate P9" with "dest3"
      And I fill in "Bed P12" with "12"
      And I fill in "Plate P12" with "dest4"
      And I fill in "Witness barcode" with "2470041440697"
      And I press "Submit"
    Then I should see "Success"
      And I should be on the new audit page
    Given all pending delayed jobs are processed
    # The delayed job will raise an exception if it fails

  Scenario Outline: Plates scanned in wrong order
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": <plate_size>
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest2" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": <plate_size>
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest3" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": <plate_size>
          }]
      }
      """
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest4" returns the following JSON:
      """
      {
          "searches": [{
              "name": "<destination_plate_name>",
              "size": <plate_size>
          }]
      }
      """
    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Sequenom" from AJAX dropdown "Instrument process"
      And I fill in "Bed P2" with "<bed_p2>"
      And I fill in "Plate P2" with "<source_1>"
      And I fill in "Bed P5" with "<bed_p5>"
      And I fill in "Plate P5" with "<source_2>"
      And I fill in "Bed P8" with "<bed_p8>"
      And I fill in "Plate P8" with "<source_3>"
      And I fill in "Bed P11" with "<bed_p11>"
      And I fill in "Plate P11" with "<source_4>"
      And I fill in "Bed P3" with "<bed_p3>"
      And I fill in "Plate P3" with "<destination_1>"
      And I fill in "Bed P6" with "<bed_p6>"
      And I fill in "Plate P6" with "<destination_2>"
      And I fill in "Bed P9" with "<bed_p9>"
      And I fill in "Plate P9" with "<destination_3>"
      And I fill in "Bed P12" with "<bed_p12>"
      And I fill in "Plate P12" with "<destination_4>"
      And I press "Submit"
    Then I should see "<error_message>"
    Examples:
      | source_1      | source_2      | source_3      | source_4      | destination_1 | destination_2 | destination_3 | destination_4 | destination_plate_name | error_message                            | bed_p2 | bed_p5 | bed_p8 | bed_p11 | bed_p3 | bed_p6 | bed_p9 | bed_p12 | plate_size |
      | 6250000004773 |               |               |               | dest1         |               |               |               | QC1____20101110        | Invalid source plate order               | 2      |        |        |         | 3      |        |        |         | 384        |
      | 6250000004773 | 6250000003769 |               |               | dest1         |               |               |               | QC1_2___20101110       | Invalid source plate order               | 2      | 5      |        |         | 3      |        |        |         | 384        |
      | 6250000004773 | 6250000003769 | 6250000002755 |               | dest1         |               |               |               | QC1_2_3__20101110      | Invalid source plate order               | 2      | 5      | 8      |         | 3      |        |        |         | 384        |
      | 6250000004773 | 6250000003769 | 6250000002755 | 6250000001741 | dest1         |               |               |               | QC1_2_3_4_20101110     | Invalid source plate order               | 2      | 5      | 8      | 11      | 3      |        |        |         | 384        |
      |               |               |               |               | dest1         |               |               |               | QC1____20101110        | No plates scanned                        |        |        |        |         | 3      |        |        |         | 384        |
      |               | 6250000002755 |               |               | dest1         |               |               |               | QC1_2___20101110       | Invalid source plate order               |        | 5      |        |         | 3      |        |        |         | 384        |
      | 6250000004773 | 6250000004773 | 6250000004773 |               | dest1         |               |               |               | QC1_2_3__20101110      | Invalid source plate order               | 2      | 5      | 8      |         | 3      |        |        |         | 384        |
      |               | 6250000002755 | 6250000003769 | 6250000004773 | dest1         |               |               |               | QC1_2_3_4_20101110     | Invalid source plate order               |        | 5      | 8      | 11      | 3      |        |        |         | 384        |
      | 6250000001741 | 6250000002755 | 6250000003769 |               | dest1         | dest2         | dest3         | dest4         | QC1_2_3_4_20101110     | Invalid source plate order               | 2      | 5      | 8      |         | 3      | 6      | 9      | 12      | 384        |
      | 6250000001741 | 6250000002755 | 6250000003769 | 6250000004773 | dest1         | dest2         | dest1         | dest4         | QC1_2_3_4_20101110     | Destination plate scanned more than once | 2      | 5      | 8      | 11      | 3      | 6      | 9      | 12      | 384        |
      | 6250000001741 | 6250000002755 | 6250000003769 | 6250000004773 | dest1         | dest2         | dest3         | dest4         | QC1_2_3_4_20101110     | Invalid plate size, it must be 384       | 2      | 5      | 8      | 11      | 3      | 6      | 9      | 12      | 96         |

  Scenario Outline: Beds scanned in wrong order or invalid
    Given the search with UUID "00000000-0000-0000-0000-000000000001" for barcode "dest1" returns the following JSON:
      """
      {
          "searches": [{
              "name": "QC1____20101110",
              "size": 384
          }]
      }
      """
    Given I am on the new audit page
    When I fill in "User barcode" with "2470000100730"
      And I fill in AJAX field "Instrument barcode" with "abc123456"
      And I select "Sequenom" from AJAX dropdown "Instrument process"
      And I fill in "Bed P2" with "<p2_barcode>"
      And I fill in "Plate P2" with "6250000001741"
      And I fill in "Bed P3" with "<p3_barcode>"
      And I fill in "Plate P3" with "dest1"
      And I press "Submit"
    Then I should see "Invalid layout"
    Examples:
      | p2_barcode | p3_barcode |
      | 3          | 2          |
      | 2          | 2          |
      | 3          | 3          |
      | x          | x          |
