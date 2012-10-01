class String
  def split_and_symbolize(delimeter = ',')
    self.split(delimeter).map do |column| 
      column.gsub(/\s/, '_').downcase.to_sym
    end
  end
end

class Importer
  attr_reader :column_names

  def initialize(data, delimeter=',')
    @column_names, @rows = *read_data(data, delimeter)
  end

  def lines
    @rows.each_with_object([]) { |row, obj| obj << @column_names.zip(row) }
  end

  private

  def read_data(data, delimeter)
    data    = data.is_a?(Array) ? data.dup : File.readlines(data).map(&:chomp)
    content = ->{ data.each_with_object([]) { |row, obj| obj << row.split(delimeter) } }

    [data.shift.split_and_symbolize, content.call]
  end
    
end

my_contacts = Importer.new('data/contacts.csv')

