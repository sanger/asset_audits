# frozen_string_literal: true

require "singleton"
require "sinatra"

class FakeSinatraService
  include Singleton

  # Ensures that ports are assigned dynamically and that they are random, reducing the chances of
  # clashes both between the fake services in this test run, and between the fake services across
  # test runs.
  def self.take_next_port
    if @ports.nil?
      initial_port = (($PROCESS_ID % 100) * 10) + 6000 # Use pid and use a range
      @ports = (1..100).to_a.shuffle.map { |p| initial_port + p }
    end
    @ports.shift
  end

  attr_reader :port, :host

  def initialize(*_args)
    @host = "localhost"
    @port = self.class.take_next_port
  end

  def run!
    start_sinatra do |thread|
      wait_for_sinatra_to_startup!
      yield
    ensure
      kill_running_sinatra
      thread.join
      clear
    end
  end

  def self.install_hooks(target, tags)
    service = self
    target.instance_eval do
      # Ensure that, if we're running in a javascript environment, that the browser has been launched
      # before we start our service.  This ensures that the listening port is not inherited by the fork
      # within the Selenium driver.
      Before(tags) do |_scenario|
        Capybara.current_session.driver.browser if Capybara.current_driver == Capybara.javascript_driver
        service.instance.start!
      end
      After(tags) { |_scenario| service.instance.finish! }
    end
  end

  def start!
    raise StandardError, "Cannot start up multiple instances of #{self.class.name}" unless @thread.nil?

    start_sinatra do |thread|
      wait_for_sinatra_to_startup!
      @thread = thread
    end
  end

  def finish!
    kill_running_sinatra
    @thread.join
    clear
  ensure
    @thread = nil
  end

  private

  def clear
  end

  def start_sinatra
    thread =
      Thread.new do
        # The effort you have to go through to silence Sinatra/WEBrick!
        logger = Logger.new($stderr)
        logger.level = Logger::FATAL

        service.run!(host: @host, port: @port, webrick: { Logger: logger, AccessLog: [] })
      end
    yield(thread)
  end

  def kill_running_sinatra
    Net::HTTP.get(URI.parse("http://#{@host}:#{@port}/die_eat_flaming_death"))
  rescue EOFError, Errno::ECONNREFUSED, SystemExit
    # EOFError:            This is fine, it means that Sinatra apparently died.
    # Errno::ECONNREFUSED: This is probably fine too because it means it wasn't running in the first place!
    # SystemExit:          This one is probably fine to ignore too.
    true
  end

  # We have to pause execution until Sinatra has come up.  This makes a number of attempts to
  # retrieve the root document.  If it runs out of attempts it raises an exception
  def wait_for_sinatra_to_startup!
    10.times do
      Net::HTTP.get(URI.parse("http://#{@host}:#{@port}/up_and_running"))
      return
    rescue Errno::ECONNREFUSED => e # rubocop:todo Lint/UselessAssignment
      sleep(1)
    end

    raise StandardError, "Our dummy webservice did not start up in time!"
  end

  class Base < Sinatra::Base
    # rubocop:todo Metrics/MethodLength
    def self.run!(options = {}) # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
      set options
      set :server, %w[webrick] # Force Webrick to be used as it's quicker to startup & shutdown
      handler = Rack::Handler.pick(server)
      handler_name = handler.name.gsub(/.*::/, "") # rubocop:todo Lint/UselessAssignment
      handler.run(self, Host: bind, Port: port, **options.fetch(:webrick, {})) do |server|
        set :running, true
        set :quit_handler, proc { server.shutdown } # Kill the Webrick specific instance if we need to
      end
    rescue Errno::EADDRINUSE => e # rubocop:todo Lint/UselessAssignment
      raise StandardError, "== Someone is already performing on port #{port}!"
    rescue SystemExit, IOError => e
      # Ignore and continue (or rather, die).
      Rails.logger.error(e)
    end

    # rubocop:enable Metrics/MethodLength

    get("/up_and_running") do
      status(200)
      body("Up and running")
    end

    get("/die_eat_flaming_death") do
      status(200)
      body("Died!")
      settings.quit_handler
    end
  end
end
