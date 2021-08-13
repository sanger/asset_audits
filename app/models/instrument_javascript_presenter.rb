# frozen_string_literal: true

class InstrumentJavascriptPresenter
  attr_reader :ordered_beds, :column_groups

  def initialize(behaviour_class)
    @ordered_beds = behaviour_class.ordered_beds
    @column_groups = behaviour_class.column_groups
  end

  #
  # Reruns an array describing the order in which fields will gain focus.
  #
  #
  # @return [Array<Array>] An array of [field, next_field]
  #
  def tab_order
    bed_plate_pairs.each_with_index.map do |bed, index|
      # Finds the next bed, returns witness_barcode if we reach the end of the array
      next_bed = bed_plate_pairs.fetch(index + 1, 'witness_barcode')
      [bed, next_bed]
    end
  end

  #
  # An array of bed identifiers and a column number to enable highlighting
  # of paired fields.
  #
  # @return [Array<Array>] An array of [bed, column] integer arrays.
  #
  def bed_columns
    column_groups.each_with_index.flat_map do |bed_names, index|
      bed_names.map do |bed_name|
        bed_number = bed_name.tr('P', '').to_i
        [bed_number, index]
      end
    end
  end

  def total_columns
    column_groups.length
  end

  #
  # The field which will initially have focus.
  #
  # @return [String] Fir id of the initial field
  #
  def initial_bed
    bed_plate_pairs.first
  end

  private

  #
  # Robots have both bed and plate input boxes for each positions
  # When defining tab order, beds come before plates.
  #
  # @return [Array<String>] An array of field names for the given beds
  #         eg. ['p1_bed', 'p1_plate', 'p2_bed', 'p2_plate']
  #
  def bed_plate_pairs
    @bed_plate_pairs ||= ordered_beds.each_with_object([]) do |name, array|
      array << "#{name}_bed".downcase << "#{name}_plate".downcase
    end
  end
end
