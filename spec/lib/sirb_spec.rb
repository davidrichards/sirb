require File.join(File.dirname(__FILE__), "/../spec_helper")

describe Sirb do
  
  it "should attempt to load the known useful mathematical and statistical libraries" do
    LibLoader.all_libs.should be_include( *["enumerable statistics", "mathn", "matrix", "narray", "rbtree", "rgl", "rnum", "rubygems", "general statistics", "statisticus"])
  end
  
end