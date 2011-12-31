require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

require 'utility/launchers/osx'

describe Utility::Launchers::OSX do
  
  subject do
    Utility::Launchers::OSX.new
  end
  
  describe "#write" do
    it "writes the shortcut to a file" do
      subject.path = "/Applications/Preview.app"
      subject.write
    end
  end
  
end


# require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
# 
# require 'utility/enhancements'
# 
# describe String do
#   describe "#append" do
#     it 'appends the given string to each line of a string' do
#       "foo\nbar".append('baz').should == "foobaz\nbarbaz"
#     end
#   end
#   describe "#interpolate" do
#     it 'interpolates variables in the string' do
#       @@my_variable = 2
#       string = 'the value of @@my_variable is: #{@@my_variable}'
#       string.should == 'the value of @@my_variable is: #{@@my_variable}'
#       string.interpolate.should == 'the value of @@my_variable is: 2'
#     end
#     it 'makes any hash passed in available in "v" variable' do
#       string = 'My instructor taught me to #{v[:verb]} a #{v[:noun]}. Would you like me to #{v[:verb]} it for you?'
#       string.interpolate(
#         :verb => 'sing',
#         :noun => 'song'
#       ).should == "My instructor taught me to sing a song. Would you like me to sing it for you?"
#       string.interpolate(
#         :verb => 'jump',
#         :noun => 'shark'
#       ).should == "My instructor taught me to jump a shark. Would you like me to jump it for you?"
#     end
#   end
# end
