#!/usr/bin/env ruby
ROOT_PATH = File.dirname(__dir__)
require 'selenium-webdriver'
require 'csv'
require 'colorize'
require 'active_record'
require 'json'
require "#{ROOT_PATH}/models/item.rb"
require "#{ROOT_PATH}/lib/globals.rb"
require "#{ROOT_PATH}/lib/db_connection.rb"

include Globals
include DbConnection

def find_and_save_all_items
  url = 'https://stardewvalleywiki.com/Collections'
  count = 0
  $DRIVER.navigate.to(url)
  $WAIT.until {
    $DRIVER.find_element(:class, 'catlinks')
  }
  $DRIVER.find_elements(:class, 'wikitable').each do |table|
    table.find_elements(:tag_name, 'td').each do |td|
      item_name = td.text.strip
      puts item_name
      if Item.create(name: item_name)
        print '[SUCCESS]'.green
        puts " saved item #{item_name}..."
        count += 1
      else
        print '[ERROR]'.red
        puts " unable to save #{item_name}..."
      end
    end
  end
  puts '=-='.green * 25
  puts " successfully saved #{count} items!"
  puts '=-='.green * 25
  $DRIVER.close
end

find_and_save_all_items