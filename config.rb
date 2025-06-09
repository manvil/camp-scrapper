# frozen_string_literal: true

require 'dotenv/load'
puts "Loading configuration from .env file..."

# --- Browser Configuration ---
# Set the browser type for Selenium. Common options: :chrome, :firefox, :edge, :safari
BROWSER_TYPE = :chrome

# --- URLs ---
# The primary URL you intend to scrape
# The URL for the login page, if authentication is required
LOGIN_URL = ENV['LOGIN_URL']# **Update this to your actual login page URL**

# --- Authentication Credentials ---
# These are read from your .env file using ENV['VARIABLE_NAME']
# They will be nil if not set in the .env file, so handle that in your main script.
USERNAME = ENV['USERNAME']
PASSWORD = ENV['PASSWORD']

# --- Wait Times ---
# Default timeout for explicit waits (e.g., waiting for elements to appear)
DEFAULT_WAIT_TIMEOUT = 10 # seconds

# --- Other Settings (Optional) ---
# Example: Whether to run the browser in headless mode (no visible browser window)
RUN_HEADLESS = ENV.fetch('RUN_HEADLESS', 'true') == 'true' # Convert string to boolean
