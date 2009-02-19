module Sirb #:nodoc:
  # These are general methods for comparing enumerables.
  module InterEnumerableStatistics #:nodoc:
    
    # include GeneralStatistics

    def product(*x)
      x.inject(1.0) {|sum, a| sum *= a}
    end
    
    # There are going to be a lot more of these kinds of things, so pay
    # attention. 
    def to_pairs(x, y, &block)
      n = min(x.size, y.size)
      (0...n).map {|i| block.call(x[i], y[i]) }
    end
    
    def sum_pairs(x, y, z=0.0, &block)
      to_pairs(x,y,&block).inject(z) {|sum, i| sum += i}
    end
    
    # This may be completely off!!  Write the tests!
    def correlation(x, y)
      n = min(x.size, y.size)
      ( sum_pairs(x,y) { |a,b| a * b } - (( x.sum * y.sum ) / n.to_f)) / ((n - 1 ) * x.std * y.std)
    end
    alias :cor :correlation
    
    def p_max(*enums)
      n = min(*enums.map{ |x| x.size} )
      (0...n).map { |i| max(*enums.map{ |x| x[i] }) }
    end
    
    def p_min(*enums)
      n = min(*enums.map{ |x| x.size} )
      (0...n).map { |i| min(*enums.map{ |x| x[i] }) }
    end
  end
  
end