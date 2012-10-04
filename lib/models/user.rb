require 'ostruct'

class User < OpenStruct

  class << self 
    attr_reader :ids
  end

  @ids = []

  attr_accessor :courses

  def initialize(struct_hash)
    @courses = []
    super struct_hash
  end

  def self.new(struct_hash)
    @ids << struct_hash['user_id']
    super
  end

  def active? 
    @state == "active" ? true : false
  end

  def to_s
    return if courses.empty?
    [ user_name, courses.map(&:course_name) ]
  end

end
