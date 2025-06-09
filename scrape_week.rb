#frozen_string_literal: true

module ScrapeWeek
  def self.wait_timeout(wait_timeout: 10)
    @wait_timeout ||= wait_timeout || 10
  end

  def self.wait
    @wait ||= Selenium::WebDriver::Wait.new(timeout: wait_timeout)
  end

  def self.quick_wait
    @quick_wait ||= Selenium::WebDriver::Wait.new(timeout: 2)
  end

  def self.scrape_week(driver, week_string, week_start, timeout: nil) 
    puts "Scraping week: #{week_string}"
    wait_timeout(wait_timeout: timeout)
    wait.until { driver.find_element(xpath: "//strong[@class='#{ENV['NEXT_WEEK_SEEKER_ITEM_CLASS']}']/span[contains(text(), '#{week_string}')]") }

    find_open_shifts(driver, week_start).compact
  end

  def self.find_open_shifts(driver, week_start)
    puts "Finding all available shifts..."
    all_available_spans = wait.until { driver.find_elements(xpath: "//tbody/tr[@class='#{ENV['SHIFT_SUMMARY_ROW_CLASS']}']//div[@id='#{ENV['AVAILABILITY_SUB_BODY_CLASS']}']//span[contains(text(), '#{ENV['NEARBY_STRING']}')]") }

    shifts = []
    all_available_spans.each do |span|
      sleep 2
      if span.text.split(ENV['NEARBY_STRING']).first.to_i > 0
        puts "Found available shift: #{span.text}"
        ancestor_td = span.find_element(xpath: 'ancestor::td')
        cell_id = ancestor_td.attribute('id')
        cell_number = cell_id.split('summaryCell').last.to_i
        puts "Ancestor Element ID: #{cell_number}"
        time_of_day = cell_number <= 5 ? 'morning' : 'afternoon'
        nth_index = cell_number <= 5 ? cell_number - 1 : cell_number - 6
        day = week_start + nth_index.days
        span.click
        sleep 2
        service_detail = wait.until { driver.find_elements(xpath: "//table[@class='#{ENV['SERVICE_TABLE_CLASS']}']//tr[1]//td[2]") }
        service_detail = service_detail.map(&:text).reject(&:empty?)
        puts "Service Details: #{service_detail} "
        shifts << { day:, time_of_day:, cell_id:, service_detail:  }
        sleep 1
        begin
          quick_wait.until { driver.find_element(xpath: "//button[text()='Go Back']").click }
        rescue Selenium::WebDriver::Error::TimeoutError, Selenium::WebDriver::Error::NoSuchElementError
        end
      end
    end
    shifts
  end
end
