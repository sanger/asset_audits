Feature: Verify location of plates

  Scenario: The bed verification layout should not be visible initially
    
    Then I should see "User barcode"
      And I should see "Instrument barcode"
      And I should see "Instrument process"
      And the submit button should be disabled
    Then I should not see "Plate barcode"
      And I should not see "Bed barcode"
      And I should not see "Witness"
      
      
  Scenario: Valid plates and bed positions
    
  Scenario: Beds and plate barcodes mixed up
  
  Scenario: Bed barcodes scanned in wrong order
  
  Scenario: Plate barcodes scanned in the wrong order
  
  Scenario: Plates barcodes dont exist
  
  Scenario: Bed barcodes dont exist
  
  Scenario: Beds for different instrument scanned
  
  Scenario: Witness required and provided
  
  Scenario: Witness required and not provided

  Scenario: Process has a default checklist and all boxes are checked
  
  Scenario: Process has a default checklist and one box is not checked
  
  
  
  
