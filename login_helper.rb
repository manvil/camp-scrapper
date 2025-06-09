# frozen_string_literal: true

# login_helper.rb
# This module provides a helper method to handle website login procedures.

require 'selenium-webdriver' # Necessary for WebDriver elements and waits

module LoginHelper
  # Performs a login operation on a specified website.
  #
  # @param driver [Selenium::WebDriver::Driver] The active WebDriver instance.
  # @param login_url [String] The URL of the login page.
  # @param username [String] The username or email for login.
  # @param password [String] The password for login.
  # @param wait_timeout [Integer] The maximum time (in seconds) to wait for elements.
  # @raise [Selenium::WebDriver::Error::TimeoutError] If login elements are not found within the timeout.
  # @raise [RuntimeError] If username or password are not provided (e.g., from .env).
  def self.perform_login(driver, login_url, username, password, wait_timeout: 10)
    # Basic validation to ensure credentials are not empty
    unless username && !username.strip.empty? && password && !password.strip.empty?
      raise "Username or Password is not provided."
    end

    puts "\nAttempting to log in to: #{login_url}"
    driver.navigate.to login_url
    wait = Selenium::WebDriver::Wait.new(timeout: wait_timeout)

    # Find the username/email input field and enter the username.
    # IMPORTANT: You MUST update the selector below (e.g., 'id: 'username_or_email'')
    # to match the actual HTML ID, name, class, or CSS selector of the username input field
    # on your target website's login page. Use your browser's developer tools to inspect the page.
    username_field = wait.until { driver.find_element(id: 'username') } # <<<--- UPDATE THIS SELECTOR
    username_field.send_keys(username)
    puts "Entered username."

    # Find the password input field and enter the password.
    # IMPORTANT: You MUST update the selector below (e.g., 'id: 'password'')
    # to match the actual HTML ID, name, class, or CSS selector of the password input field.
    password_field = wait.until { driver.find_element(id: 'password') } # <<<--- UPDATE THIS SELECTOR
    password_field.send_keys(password)
    puts "Entered password."

    # Find and click the login button.
    # IMPORTANT: You MUST update the selector below (e.g., 'id: 'submit_button'')
    # to match the actual HTML ID, name, class, or CSS selector of the login button.
    login_button = wait.until { driver.find_element(css: 'button[type="submit"]') }
    login_button.click
    puts "Clicked login button."

    # Optional: Add a wait for a specific element on the post-login page to confirm successful login.
    # For example, waiting for a dashboard header or a specific welcome message to appear.
    # If this element doesn't appear, the login might have failed.
    # begin
    #   wait.until { driver.find_element(css: '.dashboard-header') } # Example: Wait for a dashboard element
    #   puts "Successfully logged in and found post-login element."
    # rescue Selenium::WebDriver::Error::TimeoutError
    #   puts "Login completed, but post-login confirmation element not found within timeout. Check login status manually."
    # end
  end
end
