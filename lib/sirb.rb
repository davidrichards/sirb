$:.unshift(File.expand_path(File.dirname(__FILE__)))

require 'sirb/loader'

Dir.glob("#{File.dirname(__FILE__)}/overrides/*.rb").each { |file| require file }

require 'rubygems'
Loader.add_lib('rubygems')
Loader.add_lib('mathn')
Loader.add_lib('matrix')
Loader.add_lib('narray')
Loader.add_lib('rnum')
Loader.add_lib('rgl') { 
  require 'rgl/dot'
  require 'rgl/adjacency'
  require 'rgl/traversal'
  require 'rgl/topsort'
}
Loader.add_lib('rbtree')
Loader.add_lib('statisticus')


Loader.add_lib('scalar statistics') {
  require 'sirb/scalar_statistics'
  include Sirb::ScalarStatistics
}
Loader.add_lib('enumerable statistics') {
  require 'sirb/enumerable_statistics'
  class Array
    include Sirb::EnumerableStatistics
  end
  # TODO: Add other enumerables, adapt for Matrices, Vectors, graphs, the whole thing.
}

puts Loader.to_s