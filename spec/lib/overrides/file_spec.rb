require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe File do
  it "should have a mkdir_p method, that only creates a directory if it's missing" do
    file = "/tmp/" + (1..3).map {|x| rand(100).to_s}.join("_")
    File.should_not be_exist(file)
    File.mkdir_p(file)
    File.should be_exist(file)
    File.should be_directory(file)
    `rm -rf #{file}` # File.unlink wants other permissions, not bothering with that.
    File.should_not be_exist(file)
  end
end