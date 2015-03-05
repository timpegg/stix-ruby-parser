class CyboxType
  
end # End CyboxType

class CyboxObservable < CyboxType
  def initialize (array_of_cyboxobservable)
    @array_of_cyboxobservable = array_of_cyboxobservable
  end
end # End CyboxObservable

class CyboxObject < CyboxObservable
  def initialize (array_of_cyboxobject)
    @array_of_cyboxobject = array_of_cyboxobject
  end
end # End CyboxObject

class CyboxEvent < CyboxObservable
  def initialize (array_of_cyboxobject)
    @array_of_cyboxobject = array_of_cyboxobject
  end
end # End CyboxEvent

class CyboxObservable_Composition < CyboxObservable
  def initialize (array_of_cyboxobject)
    @array_of_cyboxobject = array_of_cyboxobject
  end
end # End CyboxObject

class CyboxObject < CyboxType
  def initialize (array_of_observable_source=nil)
  end
end # End CyboxObservablesTypes

class CyboxObservable < CyboxType
  def initialize (attribute={:id=>nil, :idref=>nil, :negate=>nil, :sighting_count=>nil}, 
                  title=nil, description=nil, keywords = nil, arrayOfObservable_source=nil, pattern_fidelity=nil)
  end

end # End CyboxObservable