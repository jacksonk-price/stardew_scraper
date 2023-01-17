#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'csv'
require 'colorize'

$OPTIONS = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# $DRIVER = Selenium::WebDriver.for(:firefox, options: $OPTIONS)
$DRIVER = Selenium::WebDriver.for :firefox
$WAIT = Selenium::WebDriver::Wait.new(:timeout => 60)

def scrape_it
  url = 'https://stardewvalleywiki.com/Villagers'
  villager_names = Array.new
  $DRIVER.navigate.to(url)
  print '[INFO] '.blue
  puts "Navigating to #{url}..."
  $WAIT.until {
    $DRIVER.find_element(:class, 'catlinks')
  }
  $DRIVER.find_elements(:class, 'gallerytext').each do |villager|
    villager_names << villager.find_element(:tag_name, 'a').text
  end

  puts villager_names.inspect

  print '[SUCCESS] '.green
  puts 'completed'
end

scrape_it