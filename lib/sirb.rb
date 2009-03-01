$:.unshift(File.expand_path(File.dirname(__FILE__)))

module Sirb
end

require 'sirb/lib_loader'

Dir.glob("#{File.dirname(__FILE__)}/overrides/*.rb").each { |file| require file }

require 'rubygems'
LibLoader.add_lib('rubygems')
LibLoader.add_lib('mathn')
LibLoader.add_lib('set')
LibLoader.add_lib('matrix')
LibLoader.add_lib('narray')
LibLoader.add_lib('rnum')
LibLoader.add_lib('rgl') { 
  require 'rgl/dot'
  require 'rgl/adjacency'
  require 'rgl/traversal'
  require 'rgl/topsort'
}
LibLoader.add_lib('tenacious_g')
LibLoader.add_lib('rbtree')
LibLoader.add_lib('statisticus')


LibLoader.add_lib('general statistics') {
  require 'sirb/general_statistics'
  include Sirb::GeneralStatistics
}

LibLoader.add_lib('enumerable statistics') {
  require 'sirb/enumerable_statistics'
  class Array
    include Sirb::EnumerableStatistics
  end
  # TODO: Add other enumerables, adapt for Matrices, Vectors, graphs, the whole thing.

  require 'sirb/inter_enumerable_statistics'
  include Sirb::InterEnumerableStatistics
  
  require 'sirb/functional'
  require 'sirb/unbound_method'
  
}

puts LibLoader.to_s if LibLoader.to_s