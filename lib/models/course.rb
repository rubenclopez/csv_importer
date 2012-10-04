require 'ostruct'

class Course < OpenStruct

  class << self
    attr_reader :ids
  end

  @ids = []

  attr_accessor :users

  def initialize(struct_hash)
    @users = []
    super struct_hash
  end

  def self.new(struct_hash)
    @ids << struct_hash['course_id']
    super
  end

  def active? 
    state == "active" ? true : false
  end

end
