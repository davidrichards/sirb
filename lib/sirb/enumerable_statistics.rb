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
    def median(ratio=0.5, &block)
      return iterate_midway(ratio, &block) if block_given?
      begin
        mid1, mid2 = middle_two
        sorted = new_sort
        med1, med2 = sorted[mid1], sorted[mid2]
        return med1 if med1 == med2
        return med1 + ((med2 - med1) * ratio)
      rescue
        iterate_midway(ratio, &block)
      end
    end
    
    def middle_two
      mid2 = size.div(2)
      mid1 = (size % 2 == 0) ? mid2 - 1 : mid2
      return mid1, mid2
    end
    
    def median_position
      middle_two.last
    end
    
    def first_half(&block)
      fh = self[0..median_position].dup
    end
    
    def second_half(&block)
      # Total crap, but it's the way R does things, and this will most likely
      # only be used to feed R some numbers to plot, if at all. 
      sh = size <= 5 ? self[median_position..-1].dup : self[median_position - 1..-1].dup
    end
    
    # An iterative version of median
    def iterate_midway(ratio, &block)
      mid1, mid2, last_value, j, sorted, sort1, sort2 = middle_two, nil, 0, new_sort, nil, nil

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
      return med1 if med1 == med2
      return med1 + ((med2 - med1) * ratio)
    end
    protected :iterate_midway
    
    # Just an array of [min, max] to comply with R uses of the work.  Use
    # range_as_range if you want a real Range. 
    def range(&block)
      [min(&block), max(&block)]
    end
    
    # Useful for setting a real range class (FixedRange).
    def range_class=(klass)
      @range_class = klass
    end
    
    def range_class
      @range_class ||= Range
    end
    
    def range_as_range(&block)
      range_class.new(min(&block), max(&block))
    end
    
    # I don't pass the block to the sort, because a sort block needs to look
    # something like: {|x,y| x <=> y}.  To get around this, set the default 
    # block on the object.
    def new_sort(&block)
      if block_given?
        map { |i| yield(i) }.sort.dup
      elsif default_block
        map { |i| default_block[*i] }.sort.dup
      else
        sort().dup
      end
    end
    
    # Doesn't overwrite things like Matrix#rank
    def rank(&block)

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
    
    # First quartile: nth_split_by_m(1, 4)
    # Third quartile: nth_split_by_m(3, 4)
    # Median: nth_split_by_m(1, 2)
    # Doesn't match R, and it's silly to try to.
    # def nth_split_by_m(n, m)
    #   sorted  = new_sort
    #   dividers = m - 1
    #   if size % m == dividers # Divides evenly
    #     # Because we have a 0-based list, we get the floor
    #     i = ((size / m.to_f) * n).floor
    #     j = i
    #   else
    #     # This reflects R's approach, which I don't think I agree with.
    #     i = (((size / m.to_f) * n) - 1)
    #     i = i > (size / m.to_f) ? i.floor : i.ceil
    #     j = i + 1
    #   end
    #   sorted[i] + ((n / m.to_f) * (sorted[j] - sorted[i]))
    # end
    
    def quantile(&block)
      [
        min(&block), 
        first_half(&block).median(0.25, &block), 
        median(&block), 
        second_half(&block).median(0.75, &block), 
        max(&block)
      ]
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
      prod = 1.0
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
        map {|i| current_max = Object.max(current_max, yield(i)) }
      elsif default_block
        map {|i| current_max = Object.max(current_max, default_block[*i]) }
      else
        map {|i| current_max = Object.max(current_max, i) }
      end
    end
    alias :cumulative_max :cum_max
    
    def cum_min(&block)
      current_min = nil
      if block_given?
        map {|i| current_min = Object.min(current_min, yield(i)) }
      elsif default_block
        map {|i| current_min = Object.min(current_min, default_block[*i]) }
      else
        map {|i| current_min = Object.min(current_min, i) }
      end
    end
    alias :cumulative_min :cum_min

  end
  
end
