require 'test_helper'

Capybara.server_port = 3001
Capybara.server_host = '0.0.0.0'
Capybara.register_driver :remote_selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch('SELENIUM_URL', 'http://selenium:4444/wd/hub'),
    desired_capabilities: :chrome,
  ).tap {|driver|
    driver.browser.file_detector = -> (args) {
      File.file?(str = args.first.to_s) ? str : nil
    }
  }
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :remote_selenium

  def setup
    host! ENV.fetch('RAILS_TEST_URL', 'http://rails:3001')
  end
end
