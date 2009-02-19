class Array
  alias :single_include? :include?
  def include?(*args)
    args.inject(true) {|val, x| val = self.single_include?(x)}
  end
end