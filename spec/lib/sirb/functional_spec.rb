require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe Functional do
  it "should implement an apply method, a reverse map" do
    a = [[1,2],[3,4]]
    sum = lambda {|x,y| x+y}
    sums = sum.apply(a)
    sums.should eql([3,7])
    sums = sum|a
    sums.should eql([3,7])
  end
  
  it "should implement a reduce method, an inverse inject" do
    data = [1,2,3,4]
    sum = lambda {|x,y| x+y}
    total = sum.reduce(data)
    total.should eql(10)
    total = sum<=data
    total.should eql(10)
  end
  
  it "should implement a compose method" do
    f = lambda {|x| x*x }
    g = lambda {|x| x+1 }
    (f.compose(g))[2].should eql(9)
    (g.compose(f))[2].should eql(5)
    (f*g)[2].should eql(9)
    (g*f)[2].should eql(5)
  end
  
  it "should be able to apply a value to the head of a parameters list" do
    product = lambda {|x,y| x*y}
    doubler = product.apply_head(2)
    doubler.call(3).should eql(6)
    doubler = product.apply_head(2,3)
    doubler.call.should eql(6)
    doubler = product >> 2
    doubler.call(3).should eql(6)
  end

  it "should be able to apply a value to the tail of a parameters list" do
    difference = lambda {|x,y| x-y }
    decrement = difference.apply_tail(1)
    decrement.call(5).should eql(4)
    decrement = difference.apply_tail(5,1)
    decrement.call.should eql(4)
    decrement = difference << 1
    decrement.call(5).should eql(4)
  end
  
  it "should be able to memoize a proc" do
    require 'benchmark'
    Benchmark::Tms[:to_f] = lambda {to_s.split(/\(|\)/)[-2].to_f}
    factorial = lambda {|x| return 1 if x==0; x*factorial[x-1]; }
    memoized_factorial = factorial.memoize
    cached_factorial = +factorial # Alias
    m1 = Benchmark.measure {factorial.call(30)}
    m2 = Benchmark.measure {factorial.call(30)}
    m3 = Benchmark.measure {memoized_factorial.call(30)}
    m4 = Benchmark.measure {memoized_factorial.call(30)}
    m5 = Benchmark.measure {cached_factorial.call(30)}
    
    # They should both be about the same
    (m1.to_f).should be_close(m2.to_f, 0.005)
    
    # A memoized function should be faster than a non-memoized one
    (m2.to_f > m4.to_f).should eql(true)
    
    # The first one is not memoized, the second is.
    (m3.to_f > m4.to_f).should eql(true)
    
    # Should both have been memoized, since they are aliases.
    (m5.to_f).should be_close(m4.to_f, 0.005)
  end
end
