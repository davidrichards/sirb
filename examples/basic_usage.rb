# require 'sirb'

@a = [3,2,6,7,14]
@b = [4,6,2,1,19]
@a.max 
@a.min 
@a.sum
# Most methods have meaningful block semantics
@a.sum {|x| x ** x}
@a.mean
@a.median 
@a.range  
@a.var
@a.std
@a.sort
@a.rank
@a.order  
@a.quantile  
@a.cum_sum
@a.cum_prod
@a.cum_max
@a.cum_min
# And some methods between lists
cor(@a,@b)
# This is the max of each pair (or set)
p_max(@a,@b)
# These take an arbitrary sized list
p_max(@a,@b, [1,2,3,4,5])
# And the min
p_min(@a,@b)
p_min(@a,@b, [1,2,3,4,5])
# Finally, some methods out in the wild for general use:
max(1,2,3,4,5)
min(1,2,3,4,5)
product(1,2,3,4,5)
to_pairs(@a,@b) { |a, b| a * b }
sum_pairs(@a,@b) { |a, b| a * b }
