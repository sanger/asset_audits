module ApplicationHelper
  def flash_messages(&block)
    [:notice, :error, :warning].map do |f|
      [f, flash[f]]
    end.reject do |_,v|
      v.blank?
    end.map do |flash_type, messages|
      yield(flash_type, messages)
    end
  end

  def get_predefined_instrument_barcodes
    [InstrumentProcess.find_by_request_instrument(false)].flatten.reduce({}) do |memo, instrument_process|
      memo[instrument_process.id] = instrument_process.instruments.first.barcode
      memo
    end
  end

end
