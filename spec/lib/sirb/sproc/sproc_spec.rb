require File.join(File.dirname(__FILE__), "/../../../spec_helper")
require File.expand_path(File.join(File.dirname(__FILE__), "/../../../../lib/stored_procedures"))

describe Sproc do
  it "should instantiate like a normal Proc" do
    lambda {@s = Sproc.new {1 + 1} }.should_not raise_error
    @s.call.should eql(2)
  end
  
  it "should have an alternate constructor, build, that takes a block" do
    lambda {@s = Sproc.build {1 + 1} }.should_not raise_error
    @s.call.should eql(2)
  end
  
  it "should have an alternate constructor, build, that takes a string" do
    lambda {@s = Sproc.build "1 + 1" }.should_not raise_error
    @s.should be_is_a(Sproc)
    @s.call.should eql(2)
  end
  
  it "should not let build take other kinds of parameters" do
    lambda {@s = Sproc.build 1 }.should raise_error
    lambda {@s = Sproc.build nil }.should raise_error
  end
end