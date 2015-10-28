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

end
