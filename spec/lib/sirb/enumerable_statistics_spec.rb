require File.join(File.dirname(__FILE__), "/../../spec_helper")

# I'm putting off the default blocks and block parameters, because I'm
# not convinced I want to use these yet, they get very confusing very
# fast. 
describe EnumerableStatistics do
  it "should find the standard deviation of a list" do
    [1,2,3].std.should eql(1.0)
    # Verified with R
    [7,12,15].std.should be_close(4.041452, 0.000001)
  end
  
  it "should find the variance of a list" do
    [1,2,3].var.should eql(1.0)
    [7,12,15].var.should be_close(16.333333, 0.000001)
  end
  
  it "should find the min" do
    [1,2,3].min.should eql(1)
  end

  it "should find the min" do
    [1,2,3].max.should eql(3)
  end
  
  it "should find the median" do
    [6,2,1].median.should eql(2)
    [6,2,1,7].median.should eql(4)
  end

end