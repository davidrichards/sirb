require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe UnboundMethod do
  it "should use [] as an alias for bind" do
    # Long form
    String[:reverse].bind("hello").call.should eql("olleh")
    # Slightly shorter form
    String[:reverse]["hello"].call.should eql("olleh")
    # Target form
    String[:reverse]["hello"][].should eql("olleh")
  end
end