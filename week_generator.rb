#frozen_string_literal: true

module WeekGenerator
  # Initializes and returns a Selenium WebDriver instance.
  #
  # @param browser_type [Symbol] The type of browser to use (e.g., :chrome, :firefox).
  # @param headless [Boolean] Whether to run the browser in headless mode (without a visible UI).
  # @return [Selenium::WebDriver::Driver] The initialized WebDriver instance.
  # @raise [ArgumentError] If an unsupported browser type is provided.
  def self.get_weeks(until_date: 2.month.from_now)
    current_date = Date.today
    current_date += 2.days if current_date.wday > 5
    current_date = current_date.beginning_of_week(:monday)
    weeks = []
    while current_date <= until_date
      start_of_week = current_date.beginning_of_week(:monday)
      end_of_week = start_of_week + 4.days
      if start_of_week.strftime("%b") != end_of_week.strftime("%b")
        weeks << ["#{start_of_week.strftime('%-d %B')} - #{end_of_week.strftime('%-d %B')}", start_of_week]
      else
        weeks << ["#{start_of_week.strftime('%-d')} - #{end_of_week.strftime('%-d %B')}", start_of_week]
      end
      current_date += 7.days
    end
    weeks
  end
end
