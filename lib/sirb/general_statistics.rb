module Sirb #:nodoc:
  # These are general statistics, things that should stand on their own as
  # concepts unattached to vectors or scalars or whatever. 
  module GeneralStatistics #:nodoc:

    def self.included(base)
      base.class_eval do
        archive_method(:max)
        archive_method(:min)
        include InstanceMethods
      end 
    end

    module InstanceMethods
      # Returns the max, the non-nil value, or nil (if both are nil).  A block
      # can be passed if a special comparison is wanted (not typically). 
      def max(*x, &block)
        return x.first if x.size == 1
        return max2(x[0], x[1], &block) if x.size == 2
        a = x.first
        (1...x.size).each { |b| 
          a = max2(a,x[b], &block) }
        a
      end

      # Returns the max, the non-nil value, or nil (if both are nil).  A block
      # can be passed if a special comparison is wanted (not typically). 
      def max2(x,y, &block)
        return y if x.nil?
        return x if y.nil?
        if block_given?
          yield(x,y)
        else
          (x <=> y) > 0 ? x : y
        end
      end

      def min(*x, &block)
        return x.first if x.size == 1
        return min2(x[0], x[1], &block) if x.size == 2
        a = x.first
        (1...x.size).each { |b| 
          a = min2(a,x[b], &block) }
        a
      end

      # Returns the min, the non-nil value, or nil (if both are nil).  A block
      # can be passed if a special comparison is wanted (not typically). 
      def min2(x,y, &block)
        return y if x.nil?
        return x if y.nil?
        if block_given?
          yield(x,y)
        else
          (x <=> y) < 0 ? x : y
        end
      end
      
    end # InstanceMethods
  end # GeneralStatistics
end # Sirb
