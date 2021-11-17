# frozen_string_literal: true

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name) # rubocop:todo Metrics/MethodLength
    case page_name
    when /the home\s?page/
      '/'
    when /the new audit page/
      new_process_plate_path
    when /the instrument management page/
      admin_instruments_path
    when /the process management page/
      admin_processes_path

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))
    else
      begin
        page_name =~ /the (.*) page/
        path_components = Regexp.last_match(1).split(/\s+/)
        send(path_components.push('path').join('_').to_sym)
      rescue StandardError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
                "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
