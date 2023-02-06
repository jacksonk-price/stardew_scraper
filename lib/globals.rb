module Globals
  $DRIVER = Selenium::WebDriver.for :firefox
  $WAIT = Selenium::WebDriver::Wait.new(:timeout => 60)
end