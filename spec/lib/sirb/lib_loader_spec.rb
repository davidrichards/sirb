require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe LibLoader do
  it "should be able to load a library by name only" do
    lambda{LibLoader.add_lib(:md5)}.should_not raise_error
    LibLoader.libs_loaded.should be_include('md5')
    defined?(MD5).should eql("constant")
  end
  
  it "should be able to custom define what loading means" do
    LibLoader.add_lib(:my_load) { @two = 1 + 1 }
    LibLoader.libs_loaded.should be_include('my_load')
    @two.should eql(2)
  end
  
  it "should have a list of all libs attempted" do
    LibLoader.add_lib(:garbage)
    LibLoader.all_libs.should be_include('garbage')
  end
  
  it "should have read access to the libs hash" do
    LibLoader.libs.should be_is_a(Hash)
    lambda{LibLoader.libs = nil}.should raise_error
  end
  
  it "should keep track of the libs loaded" do
    LibLoader.add_lib(:md5)
    LibLoader.libs_loaded.should be_include('md5')
  end
  
  it "should require a raised error to count the load as a fail (not just a false value from the experience)" do
    LibLoader.add_lib(:junk) {false}
    LibLoader.failed_libs.should_not be_include('junk')
    LibLoader.add_lib(:junk2)
    LibLoader.failed_libs.should be_include('junk2')
    LibLoader.add_lib(:junk) { raise StandardError }
    LibLoader.failed_libs.should be_include('junk')
  end
end