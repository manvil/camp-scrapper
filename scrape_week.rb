#frozen_string_literal: true

module ScrapeWeek
  def self.wait_timeout(wait_timeout: 10)
    @wait_timeout ||= wait_timeout || 10
  end

  def self.wait
    @wait ||= Selenium::WebDriver::Wait.new(timeout: wait_timeout)
  end

  def self.scrape_week(driver, week_string, week_start, timeout: nil) 
    puts "Scraping week: #{week_string}"
    wait_timeout(wait_timeout: timeout)
    wait.until { driver.find_element(xpath: "//strong[@class='my-nav-week-seeker-item']/span[contains(text(), '#{week_string}')]") }

    find_open_shifts(driver, week_start).compact
  end

  def self.find_open_shifts(driver, week_start)
    all_available_spans = wait.until { driver.find_elements(xpath: "//tbody/tr[@class='shiftSummaryRow']//div[@id='availableSubBody']//span[contains(text(), ' shifts nearby')]") }

    shifts = []
    all_available_spans.each do |span|
      if span.text.split(' shifts nearby').first.to_i > 0
        puts "Found available shift: #{span.text}"
        ancestor_td = span.find_element(xpath: 'ancestor::td')
        cell_id = ancestor_td.attribute('id')
        cell_number = cell_id.split('summaryCell').last.to_i
        puts "Ancestor Element ID: #{cell_number}"
        time_of_day = cell_number <= 5 ? 'morning' : 'afternoon'
        nth_index = cell_number <= 5 ? cell_number - 1 : cell_number - 6
        day = week_start + nth_index.days
        shifts << { day:, time_of_day:, cell_id:  }
      end
    end
    shifts
  end
end
