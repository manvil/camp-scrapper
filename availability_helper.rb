# frozen_string_literal: true

# login_helper.rb
# This module provides a helper method to handle website login procedures.

require 'selenium-webdriver' # Necessary for WebDriver elements and waits

module AvailabilityHelper
  # Performs a login operation on a specified website.
  #
  # @param driver [Selenium::WebDriver::Driver] The active WebDriver instance.
  # @param login_url [String] The URL of the login page.
  # @param username [String] The username or email for login.
  # @param password [String] The password for login.
  # @param wait_timeout [Integer] The maximum time (in seconds) to wait for elements.
  # @raise [Selenium::WebDriver::Error::TimeoutError] If login elements are not found within the timeout.
  # @raise [RuntimeError] If username or password are not provided (e.g., from .env).
  def self.update_availability(driver, wait_timeout: 10)
    # Basic validation to ensure credentials are not empty

    puts "\nAttempting click on the availability button."
    wait = Selenium::WebDriver::Wait.new(timeout: wait_timeout)

    # Find the username/email input field and enter the username.
    # IMPORTANT: You MUST update the selector below (e.g., 'id: 'username_or_email'')
    # to match the actual HTML ID, name, class, or CSS selector of the username input field
    # on your target website's login page. Use your browser's developer tools to inspect the page.
    availability_modal = wait.until { driver.find_element(id: 'dvUpdateAvailabilityReminder') } # <<<--- UPDATE THIS SELECTOR

    # Find the password input field and enter the password.
    # IMPORTANT: You MUST update the selector below (e.g., 'id: 'password'')
    # to match the actual HTML ID, name, class, or CSS selector of the password input field.
    ok_button =  wait.until { driver.find_element(css: 'input[type="button"]') }
    ok_button.click
    puts "Ok clicked."

  end
end
