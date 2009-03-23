module Sirb #:nodoc:
  # These are general methods for comparing enumerables.  This list seems
  # to grow quite a bit as I build up other libraries, so expect this to
  # grow. 
  module InterEnumerableStatistics #:nodoc:
    
    # Multiplies the values:
    # >> product(1,2,3)
    # => 6.0
    def product(*x)
      x.inject(1.0) {|sum, a| sum *= a}
    end
    
    # There are going to be a lot more of these kinds of things, so pay
    # attention. 
    def to_pairs(x, y, &block)
      n = min(x.size, y.size)
      (0...n).map {|i| block.call(x[i], y[i]) }
    end
    
    # Finds the tanimoto coefficient: the intersection set size / union set
    # size.  This is used to find the distance between two vectors.
    # >> cor([1,2,3], [2,3,5])
    # => 0.981980506061966
    # >> tanimoto_pairs([1,2,3], [2,3,5])
    # => 0.5
    def tanimoto_pairs(x,y)
      intersect(x,y).size / union(x,y).size.to_f
    end
    
    # Sometimes it just helps to have things spelled out.  These are all
    # part of the Array class. 

    # All of the left and right hand sides, excluding duplicates.
    # "The union of x and y"
    def union(x,y)
      x | y
    end
    
    # What's shared on the left and right hand sides
    # "The intersection of x and y"
    def intersect(x,y)
      x & y
    end
    
    # Everything on the left hand side except what's shared on the right
    # hand side. 
    # "The relative compliment of y in x"
    def compliment(x,y)
      x - y
    end
    
    # Everything but what's shared
    def exclusive_not(x,y)
      (x | y) - (x & y)
    end
    
    # Finds the cartesian product, excluding duplicates items and self-
    # referential pairs.  Yields the block value if given. 
    def cartesian_product(x,y, &block)
      x,y = x.uniq.dup, y.uniq.dup
      pairs = x.inject([]) do |cp, i|
        cp | y.map{|b| i == b ? nil : [i,b]}.compact
      end
      return pairs unless block_given?
      pairs.map{|p| yield p.first, p.last}
    end
    alias :cp :cartesian_product
    alias :permutations :cartesian_product
  
    # Sigma of pairs.  Returns a single float, or whatever object is sent in.
    # Example: sigma_pairs([1,2,3], [4,5,6], 0) {|x, y| x + y}
    # returns 21 instead of 21.0.
    def sigma_pairs(x, y, z=0.0, &block)
      to_pairs(x,y,&block).inject(z) {|sum, i| sum += i}
    end
    
    # Takes any number of enumerables and returns the range for all of them.
    # This is an O(n*3) operation. 
    def range_for(*args)
      range_pairs(p_max(*args), p_min(*args))
    end
    
    # Returns the range of each position between the two pairs.
    def range_pairs(x,y)
      to_pairs(x,y) {|a,b| max(a,b) - min(a,b)}
    end
    
    # Returns the Euclidian distance between all points of a set of enumerables
    def euclidian_distance(x,y)
      Math.sqrt(sigma_pairs(x,y) {|a, b| (a - b) ** 2})
    end

    # Returns a random integer in the range for any number of lists.  This
    # is a way to get a random vector that is tenable based on the sample
    # data.  For example, given two sets of numbers: 
    # 
    # a = [1,2,3]; b = [8,8,8]
    # 
    # rand_in_pair_range will return a value >= 1 and <= 8 in the first
    # place, >= 2 and <= 8 in the second place, and >= 3 and <= 8 in the
    # last place. 
    # Works for integers.  Rethink this for floats.  May consider setting up
    # FixedRange for floats.  O(n*5)
    def rand_in_range(*args)
      range = range_for(*args)
      min = p_min(*args)
      (0...range.size).inject([]) do |ary, i|
        ary << (rand(range[i] + 1) + min[i])
      end
    end
    
    # Finds the correlation between two enumerables.
    # Example: cor([1,2,3], [2,3,5) 
    # return 0.981980506061966
    def correlation(x, y)
      n = min(x.size, y.size)
      ( sigma_pairs(x,y) { |a,b| a * b } - (( x.sum * y.sum ) / n.to_f)) / ((n - 1 ) * x.std * y.std)
    end
    alias :cor :correlation
    
    # Returns the max of two or more enumerables.
    # >> p_max([1,2,3], [4,5,6], [0,2,9])
    # => [4, 5, 9]
    def p_max(*enums)
      n = min(*enums.map{ |x| x.size} )
      (0...n).map { |i| max(*enums.map{ |x| x[i] }) }
    end
    
    # Returns the min of two or more enumerables.
    # >> p_min([1,2,3], [4,5,6], [0,2,9])
    # => [0, 2, 3]
    def p_min(*enums)
      n = min(*enums.map{ |x| x.size} )
      (0...n).map { |i| min(*enums.map{ |x| x[i] }) }
    end
  end
  
end