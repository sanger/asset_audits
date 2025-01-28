function recalcNumBarcodes(textareaId, maxBarcodes) {
    const num_barcodes = find_number_barcodes($(textareaId).val());
    const colour = num_barcodes > maxBarcodes ? "red" : "green";
  
    $("#barcodes_scanned")
      .text(num_barcodes + " barcodes")
      .css("color", colour);
  }
  
  function find_number_barcodes(text) {
    const barcodes_list_no_blanks = text.split(/\s+/).filter((barcode) => Boolean(barcode));
    const barcodes_list_unique = [...new Set(barcodes_list_no_blanks)];
    return barcodes_list_unique.length;
  }
