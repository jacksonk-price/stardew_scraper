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
    save_villager_info
  end
  $DRIVER.close
end

def save_villager_info
  table = $DRIVER.find_element(:id, 'infoboxtable')
  birthday = table.find_element(:xpath, '//tbody/tr[4]/td[2]').text.strip
  lives_in = table.find_element(:xpath, '//tbody/tr[5]/td[2]').text.strip
  address = table.find_element(:xpath, '//tbody/tr[6]/td[2]').text.strip
  marriage = table.find_element(:xpath, '//tbody/tr[8]/td[2]').text.strip

  if marriage == 'Yes'
    marriage = true
  else
    marriage = false
  end

  if Villager.create(name: name, birthday: birthday, lives_in: lives_in, address: address, marriage: marriage)
    print '[SUCCESS]'.green
    puts ' saved this villager...'
  else
    print '[ERROR]'.red
    puts ' issue saving this villager...'
  end
end

scrape_it