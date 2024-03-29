# frozen_string_literal: true

require "singleton"
class Settings
  attr_accessor :settings

  include Singleton

  class << self
    def respond_to?(method, include_private: false)
      super or instance.respond_to?(method, include_private)
    end

    protected

    def method_missing(method, *, &) # rubocop:todo Style/MissingRespondToMissing
      return super unless instance.respond_to?(method)

      instance.send(method, *, &)
    end
  end

  def initialize
    filename = File.join(File.dirname(__FILE__), *%W[.. settings #{Rails.env}.yml])
    @settings = YAML.safe_load(eval(ERB.new(File.read(filename)).src, nil, filename)) # rubocop:todo Security/Eval
  end

  def respond_to?(method, include_private: false)
    super or is_settings_query_method?(method) or @settings.key?(setting_key_for(method))
  end

  protected

  def method_missing(method, *args, &) # rubocop:todo Style/MissingRespondToMissing
    setting_key = setting_key_for(method)
    setting_exists = @settings.key?(setting_key)

    if is_settings_query_method?(method)
      setting_exists
    elsif setting_exists
      @settings[setting_key]
    else
      super
    end
  end

  private

  def is_settings_query_method?(method) # rubocop:todo Naming/PredicateName
    method.to_s =~ /\?$/
  end

  def setting_key_for(method)
    method.to_s.match(/^([^?]+)\??$/)[1]
  end
end

Settings.instance
