module NextWeek
  def self.click(driver, timeout: 10)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    sleep 4
    button = wait.until do
      element = driver.find_element(xpath: "//div[@class='#{ENV['NEXT_WEEK_NAV_SEEKER_CLASS']}']/button[@id='#{ENV['NEXT_WEEK_BUTTON_ID']}']")
      element if element.displayed? && element.enabled?
    end
    button.click
    sleep 4
  end
end
