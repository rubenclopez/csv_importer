#!/usr/bin/env ruby

require 'pp'
Dir.glob('lib/models/*.rb').each { |model| require_relative model }


# NOTE: This script will import CSV provided as arguments and based on the type of file will do a has-many join and output the data in a specific order
# Model: data/user.csv
# Model: data/user2.csv
#
# Join Table: data/enrollment.csv
#
# Model: data/course.csv
# 
# Data is stored in Complex Objects
# Course, and User
#

if ARGV.empty?
 puts "Usage: csv_importer_oop.rb [CSV FILES]"
  exit 1
end

CSV_DELIMETER = ','

data = ARGV.map { |file| File.readlines(file).map { |line| line.chomp.split(CSV_DELIMETER)  } }

users       = []
enrollments = []
courses     = []

data.each do |file|
  header   = file.shift
  case 
    when (%w|course_id state user_id|     - header).empty?
      enrollments << file.map { |line| Hash[ header.zip(line) ] }
    when (%w|course_id course_name state| - header).empty?
      courses << file.map { |line| Course.new(Hash[header.zip(line)]) }
    when (%w|user_name user_type user_id| - header).empty?
      users << file.map { |line| User.new(Hash[header.zip(line)]) }
  end
end

enrollments.flatten!
courses.flatten!
users.flatten!

enrollments.each do |enrollment|
  next unless enrollment['state'] == 'active'
  if User.ids.include?(enrollment['user_id']) && Course.ids.include?(enrollment['course_id'])
    curr_user    = ->{ users.find   { |user| user.user_id == enrollment['user_id'] } }
    curr_course  = ->{ courses.find { |course| course.course_id == enrollment['course_id'] } }
    if curr_course.call.active?
      curr_user   = curr_user.call
      curr_course = curr_course.call

      curr_user.courses << curr_course
      curr_course.users << curr_user
    end
  end
end

pp users.map(&:to_s).compact
