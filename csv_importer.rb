#!/usr/bin/env ruby

require 'pp'
require_relative 'lib/csv_importer'

#data = Dir.glob('data/*.csv').map { |file| File.readlines(file).map(&:chomp) }.flatten
#header_index = Dir.glob('data/*.csv').map { |file| File.readlines(file).map(&:chomp) }.flatten.each_with_index.each_with_object([]) { |(line, index), obj| obj << index if line.match(/^\w+_id,/) }
#header_index_zipped = header_index.each_with_index.map { |number, index| [number, header_index[index+1]] }
#ap header_index.each_with_object([]) { |(from, to), obj| obj << data[from...to] if (from && to) }
#
#
#
#
# NOTE: This script will import CSV provided as arguments and based on the type of file will do a has-many join and output the data in a specific order
# Model: data/user.csv
# Model: data/user2.csv
#
# Join Table: data/enrollment.csv
#
# Model: data/course.csv
# 
# Data is stored in simple Arrays and Hashes

if ARGV.empty?
  puts "Usage: csv_importer.rb [CSV FILES]"
  exit 1
end

CSV_DELIMETER = ','

data = ARGV.map { |file| File.readlines(file).map { |line| line.chomp.split(CSV_DELIMETER)  } }

users       = []
enrollments = []
courses     = []

data.each do |file|
  header   = file.shift
  response = case 
    when (%w|course_id state user_id|     - header).empty?
      enrollments << file.map { |line| Hash[ header.zip(line) ] }
    when (%w|course_id course_name state| - header).empty?
      courses << file.map { |line| Hash[ header.zip(line) ] }
    when (%w|user_name user_type user_id| - header).empty?
      users << file.map { |line| Hash[ header.zip(line) ] }
  end
end

enrollments.flatten!
courses.flatten!
users.flatten!

uniq_usernames = []

users.each do |user|
  user['courses'] = []
  next if uniq_usernames.include?(user['user_name'])
  uniq_usernames << user['user_name']
  enrollments.each do |enrollment|
    if enrollment['user_id'].include?(user['user_id'])
      courses.each do |course|
        if enrollment['course_id'].include?(course['course_id'])
          next if enrollment['state'] == 'inactive' || course['state'] == 'inactive'
          user['courses'] << course['course_name']
        end
      end
    end
  end
end

users.each do |user|
  next if user['courses'].empty?
  puts "#{user['user_name']} has #{user['courses'].count}"

  user['courses'].each do |course|
    puts "\t#{course}"
  end
end
