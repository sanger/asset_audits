class InstrumentJavascriptPresenter
  attr_reader :ordered_beds
  def initialize(behaviour_class)
    @ordered_beds = behaviour_class.ordered_beds
  end

  def bed_plate_pairs
    @bed_plate_pairs ||= ordered_beds.each_with_object([]) do |name, array|
      array << "#{name}_bed".downcase << "#{name}_plate".downcase
    end
  end

  def tab_order
    bed_plate_pairs.each_with_index.map do |bed, index|
      # Finds the next bed, returns witness_barcode if we reach the end of the array
      next_bed = bed_plate_pairs.fetch(index + 1, 'witness_barcode')
      [bed, next_bed]
    end
  end

  def bed_columns
    ordered_beds.each_with_index.map do |bed_name, index|
      bed_number = bed_name.tr('P','').to_i
      [bed_number, index]
    end
  end

  def initial_bed
    "#{ordered_beds.first}_bed".downcase
  end
end
