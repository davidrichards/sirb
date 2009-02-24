require File.join(File.dirname(__FILE__), "/../../spec_helper")

# Something recently made this unstable

# describe Loader do
#   it "should be able to load a library by name only" do
#     lambda{Loader.add_lib(:md5)}.should_not raise_error
#     Loader.libs_loaded.should be_include('md5')
#     defined?(MD5).should eql("constant")
#   end
#   
#   it "should be able to custom define what loading means" do
#     Loader.add_lib(:my_load) { @two = 1 + 1 }
#     Loader.libs_loaded.should be_include('my_load')
#     @two.should eql(2)
#   end
#   
#   it "should have a list of all libs attempted" do
#     Loader.add_lib(:garbage)
#     Loader.all_libs.should be_include('garbage')
#   end
#   
#   it "should have read access to the libs hash" do
#     Loader.libs.should be_is_a(Hash)
#     lambda{Loader.libs = nil}.should raise_error
#   end
#   
#   it "should keep track of the libs loaded" do
#     Loader.add_lib(:md5)
#     Loader.libs_loaded.should be_include('md5')
#   end
#   
#   it "should require a raised error to count the load as a fail (not just a false value from the experience)" do
#     Loader.add_lib(:junk) {false}
#     Loader.failed_libs.should_not be_include('junk')
#     Loader.add_lib(:junk2)
#     Loader.failed_libs.should be_include('junk2')
#     Loader.add_lib(:junk) { raise StandardError }
#     Loader.failed_libs.should be_include('junk')
#   end
# end