#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'csv'
require 'colorize'

$OPTIONS = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# $DRIVER = Selenium::WebDriver.for(:firefox, options: $OPTIONS)
$DRIVER = Selenium::WebDriver.for :firefox
$WAIT = Selenium::WebDriver::Wait.new(:timeout => 60)
$NAMES = ["Alex", "Elliott", "Harvey", "Sam", "Sebastian", "Shane", "Abigail", "Emily", "Haley",
          "Leah", "Maru", "Penny", "Caroline", "Clint", "Demetrius", "Dwarf", "Evelyn", "George",
          "Gus", "Jas", "Jodi", "Kent", "Krobus", "Leo", "Lewis", "Linus", "Marnie", "Pam", "Pierre",
          "Robin", "Sandy", "Vincent", "Willy", "Wizard", "Birdie", "Bouncer", "Gil", "Governor", "Grandpa",
          "Gunther", "Henchman", "Marlon", "Morris", "Mr. Qi", "Professor Snail"]
def scrape_it
  $NAMES.each do |name|
    url = "https://stardewvalleywiki.com/#{name}"
    $DRIVER.navigate.to(url)
    print '[INFO] '.blue
    puts "Starting data collection for #{name}"
    $WAIT.until {
      $DRIVER.find_element(:class, 'catlinks')
    }
    $DRIVER.find_elements(:id, 'infoboxdetail').each do |attr|
      puts attr.text
    end

    print '[SUCCESS] '.green
    puts 'completed'
  end
end

scrape_it