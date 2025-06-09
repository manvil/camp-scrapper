#!/usr/bin/env ruby
# frozen_string_literal: true

# scraper.rb
# This is the main script that orchestrates the web scraping process.
# It utilizes the configuration, browser management, and login helper modules.

# Require the necessary custom modules and configuration
require 'active_support/all'
require_relative 'config'
require_relative 'telegram_notifier'
require_relative 'browser_manager'
require_relative 'login_helper'
require_relative 'availability_helper'
require_relative 'week_generator'
require_relative 'scrape_week'
require_relative 'next_week'

# --- Main Scraping Logic ---
# Defines the core function to perform the web scraping.
#
def scrape_website
  driver = nil # Initialize driver variable to nil to ensure it's always defined
  telegram_notifier = TelegramNotifier.new
  begin
    # Get the Selenium WebDriver instance using the BrowserManager
    # Respects the RUN_HEADLESS setting from config.rb
    driver = BrowserManager.get_driver(BROWSER_TYPE, headless: RUN_HEADLESS)
    puts "Browser '#{BROWSER_TYPE}' launched successfully."

    # --- Conditional Login Process ---
    # Check if a specific LOGIN_URL is provided and credentials are available.
  # It also checks if the username and password were successfully loaded from .env.
    begin
      # Perform login using the LoginHelper module
      LoginHelper.perform_login(driver, LOGIN_URL, USERNAME, PASSWORD, wait_timeout: DEFAULT_WAIT_TIMEOUT)
      AvailabilityHelper.update_availability(driver, wait_timeout: DEFAULT_WAIT_TIMEOUT)
    rescue RuntimeError, Selenium::WebDriver::Error::TimeoutError => e
      puts "Unable to complete operation: #{e.message}"
    end

    WeekGenerator.get_weeks.each do |week_string, week_start|
      info = ScrapeWeek.scrape_week(driver, week_string, week_start, timeout: DEFAULT_WAIT_TIMEOUT)
      # puts "Scraped week: #{info}" if info.present?
      info.each { |item| telegram_notifier.send_message("Shifts found on #{item[:day]} (#{item[:time_of_day]})") }
      NextWeek.click(driver, timeout: DEFAULT_WAIT_TIMEOUT)
    end

    puts "\nScraping complete."
  rescue => e
    # Catch any general exceptions that occur during the scraping process
    puts "An unhandled error occurred during scraping: #{e.message}"
    puts e.backtrace.join("\n")
  ensure
    # Ensure the browser is always closed, even if errors occur.
    BrowserManager.close_driver(driver)
    puts "Browser closed."
  end
end

# --- Script Execution ---
# Call the main scraping function with the TARGET_URL defined in config.rb.
scrape_website
sleep 60
