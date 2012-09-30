require_relative '../importer'


data =  [
          "First Name,Last Name,Phone,Notes",
          "FN_Test1,LN_Test1,111-111-1111,Hello world",
          "FN_Test2,LN_Test2,222-222-2222,Hello world",
          "FN_Test3,LN_Test2,333-333-3333,Hello world"
        ]

describe Importer do

  subject { Importer.new(data, delimeter=',') }

  it "should have a Importer class defined?" do
    ->{ defined?(Importer) == 'constant' && Importer.is_a?(Class) }.call.should == true
  end

end

