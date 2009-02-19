require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Array do
  it "should allow multiple paramaters for include?" do
    [1,2,3].include?(1,2).should eql(true)
  end
end