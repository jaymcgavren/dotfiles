require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

require 'models/rateable'

shared_examples_for "rateable objects" do

  before(:each) do
    @it = Object.new
    @it.extend Rateable
  end
  
  describe "#valid?" do
    it "does not require an integer" do
      @it.rating = 0.5
      @it.should be_valid
    end
    it "must be greater than zero" do
      @it.rating = -1
      @it.should_not be_valid
    end
    it "must be less than or equal to Rateable::MAX_RATING_VALUE" do
      @it.rating = Rateable::MAX_RATING_VALUE
      @it.should be_valid
      @it.rating = Rateable::MAX_RATING_VALUE + 1.0
      @it.should_not be_valid
    end
  end
  
end
