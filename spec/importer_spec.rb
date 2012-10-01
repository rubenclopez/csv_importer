require_relative '../importer'


DUMMY_DATA =  [
                "First Name,Last Name,Phone,Notes",
                "FN_Test1,LN_Test1,111-111-1111,Hello world",
                "FN_Test2,LN_Test2,222-222-2222,Hello world",
                "FN_Test3,LN_Test2,333-333-3333,Hello world"
              ]

describe Importer do

  it "should have a Importer class defined?" do
    ->{ defined?(Importer) == 'constant' && Importer.is_a?(Class) }.call.should == true
  end

  describe "New instance returns correct values" do
    before do
      @contacts = Importer.new(DUMMY_DATA)
    end

    it "responds to correct instance_methods" do
      [:column_names].each do |method|
        @contacts.respond_to?(method).should be_true
      end
    end

    it "should return the correct columns" do
      DUMMY_DATA.first.split_and_symbolize.should == @contacts.column_names
    end

    it "should return correct amount of lines" do
      @contacts.lines.count.should == 3
    end

    it "should return the first record" do
      @contacts.lines.first.first.should == [:first_name, "FN_Test1"]
    end

  end

end

