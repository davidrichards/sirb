require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe InterEnumerableStatistics do
  
  it "should calculate p_max over a series of enumerables" do
    a = [1,2,3]
    b = [3,2,1]
    c = [0,0,0]
    p_max(a,b,c).should eql([3,2,3])
  end
  
  it "should calculate a p_min over a series of enumerables" do
    a = [1,2,3]
    b = [3,2,1]
    c = [3,3,3]
    p_min(a,b,c).should eql([1,2,1])
  end
  
  it "should create an accurate correlation between two lists" do
    a = [1,2,3]
    b = [1,2,3]
    correlation(a,b).should eql(1.0)
    cor(a,b).should eql(1.0)
    a = [7,12,15]
    b = [19,21,27]
    # Verified with R
    cor(a,b).should be_close(0.9112932, 0.0000001)
  end
  
end
