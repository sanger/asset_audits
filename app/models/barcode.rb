# frozen_string_literal: true
class Barcode
  InvalidBarcode = Class.new(StandardError)

  # Sanger barcoding scheme

  def self.prefix_to_number(prefix)
    first  = prefix[0] - 64
    second = prefix[1] - 64
    first  = 0 if first < 0
    second = 0 if second < 0
    return ((first * 27) + second) * 1000000000
  end

  # NT23432S => 398002343283

  private

  def self.calculate_sanger_barcode(prefix, number)
    number_s = number.to_s
    raise ArgumentError, "Number : #{number} to big to generate a barcode." if number_s.size > 7
    human = prefix + number_s + calculate_checksum(prefix, number)
    barcode = prefix_to_number(prefix) + (number * 100)
    barcode = barcode + human[human.size - 1]
  end

  def self.calculate_barcode(prefix, number)
    barcode = calculate_sanger_barcode(prefix, number)
    barcode * 10 + calculate_ean13(barcode)
  end

  def self.calculate_checksum(prefix, number)
    string = prefix + number.to_s
    list = string.split(//)
    len  = list.size
    sum = 0
    list.each do |character|
      sum += character[0] * len
      len = len - 1
    end
    return (sum % 23 + 'A'[0]).chr
  end

  def self.split_barcode(code)
    code = code.to_s
    if code.size > 11 && code.size < 14
      # Pad with zeros
      while code.size < 13
        code = '0' + code
      end
    end
    if /^(...)(.*)(..)(.)$/ =~ code
      prefix, number, check, printer_check = $1, $2, $3, $4
    end
    [prefix, number.to_i, check.to_i]
  end

  def self.split_human_barcode(code)
    if /^(..)(.*)(.)$/ =~code
      [$1, $2, $3]
    end
  end

  def self.number_to_human(code)
    barcode = barcode_to_human(code)
    prefix, number, check = split_human_barcode(barcode)
    return number
  end

  def self.prefix_from_barcode(code)
    barcode = barcode_to_human(code)
    prefix, number, check = split_human_barcode(barcode)
    return prefix
  end

  def self.prefix_to_human(prefix)
    human_prefix = ((prefix.to_i / 27) + 64).chr + ((prefix.to_i % 27) + 64).chr
  end

  def self.barcode_to_human(code)
    bcode = nil
    prefix, number, check = split_barcode(code)
    human_prefix = prefix_to_human(prefix)
    if calculate_barcode(human_prefix, number.to_i) == code.to_i
      bcode = "#{human_prefix}#{number}#{check.chr}"
    end
    bcode
  end

  # Returns the Human barcode or raises an InvalidBarcode exception if there is a problem.  The barcode is
  # considered invalid if it does not translate to a Human barcode or, when the optional +prefix+ is specified,
  # its human equivalent does not match.
  def self.barcode_to_human!(code, prefix = nil)
    human_barcode = barcode_to_human(code) or raise InvalidBarcode, "Barcode #{code} appears to be invalid"
    unless prefix.nil? or split_human_barcode(human_barcode).first == prefix
      raise InvalidBarcode, "Barcode #{code} (#{human_barcode}) does not match prefix #{prefix}"
    end
    human_barcode
  end

  def self.check_ean(code)
    # the EAN checksum is calculated so that the EAN of the code with checksum added is 0
    # except the new column (the checksum) start with a different weight (so the previous column keep the same weight)
    calculate_ean(code, 1) == 0
  end

  def self.calculate_ean13(code)
    calculate_ean(code)
  end

  private

  def self.calculate_ean(code, initial_weight = 3)
    # The EAN is calculated by adding each digit modulo 10 ten weighted by 1 or 3 ( in seq)
    code = code.to_i
    ean = 0
    weight = initial_weight
    while code > 0
      code, c = code.divmod 10
      ean += c * weight % 10
      weight = weight == 1 ? 3 : 1
    end

    (10 - ean) % 10
  end
end
