module Utility


class Filter
  require 'observer'
  include Observable
  def update(*objects)
    passed_objects = objects.find_all {|o| passed?(o)}
    unless passed_objects.empty?
      changed
      notify_observers(passed_objects)
    end
  end
  def passed?(object)
    raise NotImplementedException
  end
  def link(observer)
    add_observer(observer)
    observer
  end
end


#Notifies observers of any object whose to_s method matches at least one of the given regexps.
class RegexpFilter < Filter
  #A list of regexps to scan for.
  attr_accessor :regexps
  #Set up attributes.
  def initialize(regexps = [])
    @regexps = regexps
  end
  #Scan object.to_s for regexes.
  def passed?(object)
    @regexps.find {|p| p =~ object.to_s}
  end
end


#Notifies observers of any object that this filter has not processed before.
class UnseenFilter < Filter
  #A list of values already seen by this filter.
  attr_accessor :seen_values
  #Set up attributes.
  def initialize(seen_values = [])
    @seen_values = seen_values
  end
  #True if object is not among seen_values.
  def passed?(object)
    ! @seen_values.include?(object)
  end
end


end #module Utility
