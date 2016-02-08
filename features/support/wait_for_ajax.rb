module WaitForAjax
  # Capybara bugfix
  # Reference: 
  # <https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara>
  #
  def waiting_max_wait_time
    # This is the number of seconds maximum we'll wait for ajax answers
    30
  end

  def wait_for_ajax
    Timeout.timeout(waiting_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

World(WaitForAjax)
