module Sirb #:nodoc:

  # These are the standard R vector functions that I want to add to any
  # Enumerable class for Ruby.  I started by borrowing heavily from
  # Gotoken' math/statistics project 
  # (http://raa.ruby-lang.org/project/math-statistics/).  There were a few
  # changes that don't make sense in the idiomatic Ruby that I now use (a
  # few things have changed since 2001). 
  # 
  # The following is a table of values from R to my methods
  # 
  # max         | max                                  
  # min         | min                                  
  # sum         | sum                                  
  # mean        | mean                                 
  # median      | median                               
  # range       | range                                
  # var         | var variance                         
  # cor         | cor correlation                      
  # sort        | sort                                 
  # rank        | rank                                 
  # order       | order                                
  # quantile    | quantile                             
  # cumsum      | cum_sum cumulative_sum                
  # cumprod     | cum_prod cumulative_product           
  # cummax      | cum_max cumulative_max                
  # cummin      | cum_min cumulative_min                
  # pmax        | p_max                                 
  # pmin        | p_min                                 
  
  module EnumerableStatistics

    # There are issues with this...
    include GeneralStatistics      

    def self.append_features(mod)
      
      alias :original_max :max
      alias :original_min :min
      
      unless mod < Enumerable
        raise TypeError, 
          "`#{self}' can't be included non Enumerable (#{mod})"
      end

      def mod.default_block= (block)
        self.const_set("STAT_BLOCK", block)
      end

      def mod.default_block
        defined?(self::STAT_BLOCK) && self::STAT_BLOCK
      end

      super
    end

    def default_block
      @stat_block || self.class.default_block
    end

    def default_block=(block)
      @stat_block = block
    end

    def sum
      sum = 0.0
      if block_given?
        each{|i| sum += yield(i)}
      elsif default_block
        each{|i| sum += default_block[*i]}
      else
        each{|i| sum += i}
      end
      sum
    end

    def average(&block)
      sum(&block)/size
    end
    alias :mean :average
    alias :avg :average

    def variance(&block)
      m = mean(&block)
      sum_of_differences = if block_given?
        sum{ |i| j=yield(i); (m - j) ** 2 }
      elsif default_block
        sum{ |i| j=default_block[*i]; (m - j) ** 2 }
      else
        sum{ |i| (m - i) ** 2 }
      end
      sum_of_differences / (size - 1)
    end
    alias :var :variance

    def standard_deviation(&block)
      Math::sqrt(variance(&block))
    end
    alias :std :standard_deviation

    def min(&block)
      list = if block_given?
        map{|x| yield(x) }
      elsif default_block
        map{|x| default_block[*x] }
      else
        self
      end
      Object.min(*list)
    end
    
    def max
      list = if block_given?
        map{|x| yield(x) }
      elsif default_block
        map{|x| default_block[*x] }
      else
        self
      end
      Object.max(*list)
    end
    
    # The slow way is to iterate up to the middle point.  A faster way is to
    # use the index, when available.  If a block is supplied, always iterate
    # to the middle point. 
    def median(&block)
      return iterate_midway(&block) if block_given?
      begin
        mid1 = size.div(2)
        mid2 = (size % 2 == 0) ? size.div(2) : (size / 2.0).ceil
        # I don't pass the block to the sort, because a sort block needs to look
        # something like: {|x,y| x <=> y}.  To get around this, set the default 
        # block on the object.
        sorted = new_sort
        med1 = sorted[mid1]
        med2 = sorted[mid2]
        puts 'aaaaaaaaaaaaa', mid1, mid2
        (med1 + med2) / 2
      rescue
        iterate_midway(&block)
      end
    end
    
    # An iterative version of median
    def iterate_midway(&block)
      mid1, mid2, last_value, j = size.div(2), (size / 2.0).ceil, nil, 0
      # I don't pass the block to the sort, because a sort block needs to look
      # something like: {|x,y| x <=> y}.  To get around this, set the default 
      # block on the object.
      sorted, sort1, sort2 = new_sort, nil, nil

      if block_given?
        sorted.each do |i|
          last_value = yield(i)
          j += 1
          sort1 = last_value if j == mid1
          sort2 = last_value if j == mid2
          break if j >= mid2
        end
      elsif default_block
        sorted.each do |i|
          last_value = default_block[*i]
          j += 1
          sort1 = last_value if j == mid1
          sort2 = last_value if j == mid2
          break if j >= mid2
        end
      else
        sorted.each do |i|
          last_value = i
          sort1 = last_value if j == mid1
          sort2 = last_value if j == mid2
          j += 1
          break if j >= mid2
        end
      end
      return (med1 + med2) / 2
    end
    protected :iterate_midway
    
    # Just an array of [min, max] to comply with R uses of the work.  Use
    # range_as_range if you want a real Range. 
    def range(&block)
      [Min(&block), Max(&block)]
    end
    
    # Useful for setting a real range class (FixedRange).
    def range_class=(klass)
      @range_class = klass
    end
    
    def range_class
      @range_class ||= Range
    end
    
    def range_as_range(&block)
      range_class.new(Min(&block), Max(&block))
    end
    
    def new_sort(&block)
      if block_given?
        map { |i| yield(i) }.sort
      elsif default_block
        map { |i| default_block[*i] }.sort
      else
        sort()
      end
    end
    
    # Doesn't overwrite things like Matrix#rank
    def rank(&block)

      # I don't pass the block to the sort, because a sort block needs to look
      # something like: {|x,y| x <=> y}.  To get around this, set the default 
      # block on the object.
      sorted = new_sort

      if block_given?
        map { |i| sorted.index(yield(i)) + 1 }
      elsif default_block
        map { |i| sorted.index(default_block[*i]) + 1 }
      else
        map { |i| sorted.index(i) + 1 }
      end

    end unless defined?(rank)

    # Given values like [10,5,5,1]
    # Rank should produce something like [4,2,2,1]
    # And order should produce something like [4,2,3,1]
    # The trick is that rank skips as many as were duplicated, so there
    # could not be a 3 in the rank from the example above. 
    def order(&block)
      hold= []
      rank(&block).each_with_index do |x, i|
        j = i
        while hold.include?(j) do
          j += 1
        end
        hold << j
      end
    end
    
    def quantile(&block)
      ordered = order(&block)
      first = size.div(4) - 1
      third = (size * 0.75).floor - 1
      [Min(&block), ordered[first], median(&block), ordered[third], Max(&block)]
    end
    
    def cum_sum(sorted=false, &block)
      sum = 0.0
      obj = sorted ? self.new_sort : self
      if block_given?
        obj.map { |i| sum += yield(i) }
      elsif default_block
        obj.map { |i| sum += default_block[*i] }
      else
        obj.map { |i| sum += i }
      end
    end
    alias :cumulative_sum :cum_sum

    def cum_prod(sorted=false, &block)
      prod = 0.0
      obj = sorted ? self.new_sort : self
      if block_given?
        obj.map { |i| prod *= yield(i) }
      elsif default_block
        obj.map { |i| prod *= default_block[*i] }
      else
        obj.map { |i| prod *= i }
      end
    end
    alias :cumulative_product :cum_prod
    
    def cum_max(&block)
      current_max = nil
      if block_given?
        map {|i| max(current_max, yield(i)) }
      elsif default_block
        map {|i| max(current_max, default_block[*i]) }
      else
        map {|i| max(current_max, i) }
      end
    end
    
    def cum_min(&block)
      current_min = nil
      if block_given?
        map {|i| min(current_min, yield(i)) }
      elsif default_block
        map {|i| min(current_min, default_block[*i]) }
      else
        map {|i| min(current_min, i) }
      end
    end

  end
  
end
