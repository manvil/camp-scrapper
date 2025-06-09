# frozen_string_literal: true
require 'selenium-webdriver' # Necessary for WebDriver elements and waits

module LoginHelper
  def self.perform_login(driver, login_url, username, password, wait_timeout: 10)
    # Basic validation to ensure credentials are not empty
    unless username && !username.strip.empty? && password && !password.strip.empty?
      raise "Username or Password is not provided."
    end

    puts "\nAttempting to log in to: #{login_url}"
    driver.navigate.to login_url
    wait = Selenium::WebDriver::Wait.new(timeout: wait_timeout)

    username_field = wait.until { driver.find_element(id: ENV['USERNAME_FIELD_ID']) }
    username_field.send_keys(username)
    puts "Entered username."

    password_field = wait.until { driver.find_element(id: ENV['PASSWORD_FIELD_ID']) }
    password_field.send_keys(password)
    puts "Entered password."

    login_button = wait.until { driver.find_element(css: 'button[type="submit"]') }
    login_button.click
    puts "Clicked login button."
  end
end
