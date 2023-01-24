#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'csv'
require 'colorize'
require 'active_record'
require './villager.rb'

$OPTIONS = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# $DRIVER = Selenium::WebDriver.for(:firefox, options: $OPTIONS)
$DRIVER = Selenium::WebDriver.for :firefox
$WAIT = Selenium::WebDriver::Wait.new(:timeout => 60)
$NAMES = ["Alex", "Elliott", "Harvey", "Sam", "Sebastian", "Shane", "Abigail", "Emily", "Haley",
          "Leah", "Maru", "Penny", "Caroline", "Clint", "Demetrius", "Dwarf", "Evelyn", "George",
          "Gus", "Jas", "Jodi", "Kent", "Krobus", "Leo", "Lewis", "Linus", "Marnie", "Pam", "Pierre",
          "Robin", "Sandy", "Vincent", "Willy", "Wizard", "Birdie", "Bouncer", "Gil", "Governor", "Grandpa",
          "Gunther", "Henchman", "Marlon", "Morris", "Mr. Qi", "Professor Snail"]

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  database: 'stardew_scraper',
  username: 'root',
  password: 'password'
)

def scrape_it
  $NAMES.each do |name|
    url = "https://stardewvalleywiki.com/#{name}"
    $DRIVER.navigate.to(url)
    print '[INFO] '.blue
    puts "Starting data collection for #{name}"
    $WAIT.until {
      $DRIVER.find_element(:class, 'catlinks')
    }
    villager_info = collect_table_info
    puts name
    puts villager_info[:birthday]
    puts villager_info[:lives_in]
    puts villager_info[:address]
    puts villager_info[:clinic_visit]
    puts villager_info[:marriage]
    villager = Villager.new(
      name: name,
      birthday: villager_info[:birthday],
      lives_in: villager_info[:lives_in],
      address: villager_info[:address],
      marriage: villager_info[:marriage]
    )
    villager.save
    print '[SUCCESS] '.green
    puts 'completed'
  end
  $DRIVER.close
end

def collect_table_info
  villager_info = Hash.new
  table = $DRIVER.find_element(:id, 'infoboxtable')
  birthday = table.find_element(:xpath, '//tbody/tr[4]/td[2]').text
  lives_in = table.find_element(:xpath, '//tbody/tr[5]/td[2]').text
  address = table.find_element(:xpath, '//tbody/tr[6]/td[2]').text
  # family = table.find_element(:xpath, '//tbody/tr[7]/td[2]').text
  marriage = table.find_element(:xpath, '//tbody/tr[8]/td[2]').text
  # best_gifts = table.find_element(:xpath, '//tbody/tr[10]/td[2]').text

  villager_info[:birthday] = birthday
  villager_info[:lives_in] = lives_in
  villager_info[:address] = address
  marriage == 'Yes' ? villager_info[:marriage] == true : villager_info[:marriage] == false
  villager_info
end

scrape_it