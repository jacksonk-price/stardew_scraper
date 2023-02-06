#!/usr/bin/env ruby
ROOT_PATH = File.dirname(__dir__)
require 'selenium-webdriver'
require 'csv'
require 'colorize'
require "#{ROOT_PATH}/lib/globals.rb"

include Globals

def scrape_it
  url = 'https://stardewvalleywiki.com/Villagers'
  villager_names = Array.new
  $DRIVER.navigate.to(url)
  print '[INFO] '.blue
  puts "Navigating to #{url}..."
  print '[INFO] '.blue
  puts "Collecting villager names..."
  $WAIT.until {
    $DRIVER.find_element(:class, 'catlinks')
  }
  $DRIVER.find_elements(:class, 'gallerytext').each do |villager|
    villager_names << villager.find_element(:tag_name, 'a').text
  end

  puts villager_names.inspect

  print '[SUCCESS] '.green
  puts 'completed'
  $DRIVER.close
end

scrape_it