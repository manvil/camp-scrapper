# frozen_string_literal: true

# browser_manager.rb
# This module encapsulates the logic for managing Selenium browser drivers.
# It handles initializing the browser (with optional headless mode) and closing it.

require 'selenium-webdriver'
require 'webdrivers' # Automatically downloads and manages browser drivers (e.g., ChromeDriver)

module BrowserManager
  # Initializes and returns a Selenium WebDriver instance.
  #
  # @param browser_type [Symbol] The type of browser to use (e.g., :chrome, :firefox).
  # @param headless [Boolean] Whether to run the browser in headless mode (without a visible UI).
  # @return [Selenium::WebDriver::Driver] The initialized WebDriver instance.
  # @raise [ArgumentError] If an unsupported browser type is provided.
  def self.get_driver(browser_type, headless: false)
    # Configure browser-specific options based on the browser type.
    options = case browser_type
              when :chrome
                Selenium::WebDriver::Chrome::Options.new.tap do |opts|
                  opts.add_argument('--headless') if headless # Run Chrome without a visible window
                  opts.add_argument('--disable-gpu') if headless # Recommended for headless on some systems
                  opts.add_argument('--no-sandbox') if headless # Often needed in CI/Docker environments for headless
                end
              when :firefox
                Selenium::WebDriver::Firefox::Options.new.tap do |opts|
                  opts.add_argument('--headless') if headless # Run Firefox without a visible window
                end
              # Add more browser configurations here if you plan to support Edge, Safari, etc.
              # when :edge
              #   Selenium::WebDriver::Edge::Options.new.tap do |opts|
              #     opts.add_argument('--headless') if headless
              #   end
              else
                raise ArgumentError, "Unsupported browser type: #{browser_type}. Supported types are :chrome, :firefox."
              end

    # Create and return the WebDriver instance.
    Selenium::WebDriver.for(browser_type, options: options)
  end

  # Closes the provided Selenium WebDriver instance if it exists.
  #
  # @param driver [Selenium::WebDriver::Driver, nil] The WebDriver instance to close.
  def self.close_driver(driver)
    driver.quit if driver # Ensure the driver is not nil before attempting to quit
  end
end
