class CyboxType
end # End CyboxType

class CyboxObservables < CyboxType
  def initialize (attribute={:cybox_major_version=>nil, :cybox_minor_version=>nil, :cybox_update_version=>nil}, arrayOfObservable = nil)
    raise "wrong type: attribute must have a cybox_major_version key" unless attribute.has_key?(:cybox_major_version)
    raise "wrong type: attribute must have a cybox_minor_version key" unless attribute.has_key?(:cybox_minor_version)
    raise "wrong type: attribute must have a cybox_update_version key" unless attribute.has_key?(:cybox_update_version)
    @arrayOfObservables = arrayOfObservables
  end
end # End CyboxObservables


class CyboxObservableType < CyboxType
  def initialize (attribute={:id=>nil, :idref=>nil, :negate=>nil, :sighting_count=>nil}, 
                  title=nil, description=nil, keywords = nil, arrayOfObservable_source=nil, pattern_fidelity=nil)
                  
    raise "wrong type: attribute must have a id key" unless attribute.has_key?(:id)
    raise "wrong type: attribute must have a idref key" unless attribute.has_key?(:idref)
    raise "wrong type: attribute must have a negate key" unless attribute.has_key?(:negate)
    raise "wrong type: attribute must have a sighting_count key" unless attribute.has_key?(:sighting_count)
  end
end # End CyboxObservablesTypes

class CyboxObservable < CyboxType
  def initialize (attribute={:id=>nil, :idref=>nil, :negate=>nil, :sighting_count=>nil}, 
                  title=nil, description=nil, keywords = nil, arrayOfObservable_source=nil, pattern_fidelity=nil)
  end

end # End CyboxObservable