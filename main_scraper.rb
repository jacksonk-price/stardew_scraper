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
    collect_table_info
    print '[SUCCESS] '.green
    puts 'completed'
  end
  $DRIVER.close
end

def collect_table_info
  table = $DRIVER.find_element(:id, 'infoboxtable')
  birthday = table.find_element(:xpath, '//tbody/tr[4]/td[2]').text
  lives_in = table.find_element(:xpath, '//tbody/tr[5]/td[2]').text
  address = table.find_element(:xpath, '//tbody/tr[6]/td[2]').text
  family = table.find_element(:xpath, '//tbody/tr[7]/td[2]').text
  marriage = table.find_element(:xpath, '//tbody/tr[8]/td[2]').text
  clinic_visit = table.find_element(:xpath, '//tbody/tr[9]/td[2]').text
  best_gifts = table.find_element(:xpath, '//tbody/tr[10]/td[2]').text

  puts '*' * 30
  puts birthday
  puts lives_in
  puts address
  puts family
  puts marriage
  puts clinic_visit
  puts best_gifts
  puts '*' * 30
end

scrape_it