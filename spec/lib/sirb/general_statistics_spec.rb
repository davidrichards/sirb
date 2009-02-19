require File.join(File.dirname(__FILE__), "/../../spec_helper")

describe GeneralStatistics do
  it "should safely create a max method (aliasing an existing max to original_max)" do
    class CheckMaxOne
      def max
        'original max'
      end
      include GeneralStatistics
    end
    
    @c = CheckMaxOne.new
    @c.original_max.should eql('original max')
    @c.max(1,2,3).should eql(3)
    @c.max(1,2).should eql(2)
    @c.max(1).should eql(1)
    @c.max.should be_nil
    Object.send(:remove_const, :CheckMaxOne)
  end

  it "should safely create a min method (aliasing an existing min to original_min)" do
    class CheckMinOne
      def min
        'original min'
      end
      include GeneralStatistics
    end
    
    @c = CheckMinOne.new
    @c.original_min.should eql('original min')
    @c.min(1,2,3).should eql(1)
    @c.min(1,2).should eql(1)
    @c.min(1).should eql(1)
    @c.min.should be_nil
    Object.send(:remove_const, :CheckMinOne)
  end

end