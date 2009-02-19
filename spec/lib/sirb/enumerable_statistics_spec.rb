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
    [6,2,1,7].median.should eql(4.0)
  end
  
  it "should offer the range" do
    [1,2,3,4,5].range.should eql([1,5])
    [5,2,2,3,3,1,4,5].range.should eql([1,5])
  end
  
  it "should offer range in a given class with range_as_range" do
    class MyRange < Range; end
    a = [1,2,3]
    a.range_class = MyRange
    a.range_as_range.should be_is_a(MyRange)
    Object.send(:remove_const, :MyRange)
  end
  
  it "should offer the rank of a list" do
    a = [4,2,6]
    a.rank.should eql([2,1,3])
  end
  
  it "should offer the order of the list" do
    [10,5,5,1].order.should eql([4,2,2,1])
  end
  
  it "should offer the quantile of the list" do
    # This reflects R's approach, which I don't agree with.
    [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0].quantile.should eql([1.0, 3.25, 5.5, 7.75, 10.0])
    [1.0, 2.0, 3.0, 4.0, 5.0].quantile.should eql([1.0, 2.0, 3.0, 4.0, 5.0])
  end
  
  it "should offer a cumulative sum" do
    [1,2,3].cum_sum.should eql([1.0, 3.0, 6.0])
  end
  
  it "should offer a cumulative product" do
    [1,2,3].cum_prod.should eql([1.0, 2.0, 6.0])
  end
  
  it "should offer a cumulative max" do
    [3,2,1].cum_max.should eql([3,3,3])
    [1,5,3,2,1].cum_max.should eql([1,5,5,5,5])
  end

  it "should offer a cumulative max" do
    [1,2,3].cum_min.should eql([1,1,1])
    [5,1,3,2,1].cum_min.should eql([5,1,1,1,1])
  end

end