#!/usr/bin/env ruby
ROOT_PATH = File.dirname(__dir__)
require 'selenium-webdriver'
require 'csv'
require 'colorize'
require 'active_record'
require 'json'
require "#{ROOT_PATH}/models/villager.rb"
require "#{ROOT_PATH}/config/config.rb"
require "#{ROOT_PATH}/config/db.rb"

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
    villager_info = collect_table_info
    puts name
    puts villager_info[:birthday]
    puts villager_info[:lives_in]
    puts villager_info[:address]
    puts villager_info[:marriage]
    villager = Villager.new(
      name: name,
      birthday: villager_info[:birthday],
      lives_in: villager_info[:lives_in],
      address: villager_info[:address],
      marriage: villager_info[:marriage]
    )
    if villager.save
      print '[SUCCESS] '.green
      puts 'completed'
    else
      print '[ERROR] '.red
      puts "issue saving #{name}"
    end
  end
  $DRIVER.close
end

def collect_table_info
  villager_info = Hash.new
  table = $DRIVER.find_element(:id, 'infoboxtable')
  birthday = table.find_element(:xpath, '//tbody/tr[4]/td[2]').text.strip
  lives_in = table.find_element(:xpath, '//tbody/tr[5]/td[2]').text.strip
  address = table.find_element(:xpath, '//tbody/tr[6]/td[2]').text.strip
  # family = table.find_element(:xpath, '//tbody/tr[7]/td[2]').text
  begin
    marriage = table.find_element(:xpath, '//tbody/tr[8]/td[2]').text.strip
  rescue Selenium::WebDriver::Error::NoSuchElementError
    print '[WARNING] '.yellow
    puts "issue saving "
  end
  # best_gifts = table.find_element(:xpath, '//tbody/tr[10]/td[2]').text

  villager_info[:birthday] = birthday
  villager_info[:lives_in] = lives_in
  villager_info[:address] = address
  if marriage == 'Yes'
    villager_info[:marriage] = true
  else
    villager_info[:marriage] = false
  end
  villager_info
end

scrape_it