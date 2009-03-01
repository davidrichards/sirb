require File.join(File.dirname(__FILE__), "/../../../spec_helper")

describe Proc do
  it "should be able to create a sproc from itself" do
    p = Proc.new { 1 + 1 }
    p.to_sproc.call.should eql(2)
    p.to_sproc.should be_is_a(Sproc)
  end
end