#indicators are a namespace with the following children
#  Type
#  Description
#  Observable
#  Kill_Chain_Phases
#  Sightings


class Indicators
  
  def initialize( id = nil, version = nil, xsiType = nil, content = nil)  
    # Instance variables  
    @id = id  
    @version = version  
    @xsiType = xsiType
    @content = content
  end  

  def to_s  
    "(#@type, #@id, #@version, #@xsiType, #@content)"  
  end  

end

class IndicatorType < Indicators
  
  def initialize(xsiType, content)  
     # Instance variables  
     super(type = "type", nil, nil, xsiType, content)
   end  
  
end


class IndicatorDescription < Indicators
  
  def initialize(content)  
     # Instance variables  
     super(type = "description", nil, nil, nil, content)
   end  
  
end

class IndicatorKillChainPhases < Indicators
  
  def initialize(xsiType, content)  
     # Instance variables  
     super(type = "killChainPhase", nil, nil, nil, content)
   end  
  
end

class IndicatorSightings < Indicators
  
  def initialize(sightings_count, arrayOfSighting)  
     # Instance variables  
     super(type = "sightings", nil, nil, nil, arrayOfSighting)
     @sightings_count = sightings_count
  end  
  
  def to_s  
    "(#@type, #@id, #@version, #@xsiType, [ " + @content.join(" ") + " ])"
  
  end  
   
end

class IndicatorSighting < Indicators
  
  def initialize(timeStamp)  
     # Instance variables  
     super("sighting", nil, nil, nil, timeStamp)
   end  
  
end


class IndicatorObservable < Indicators
  
  def initialize(id, content)  
     # Instance variables  
     super("observable", id, nil, nil, content)
   end  
  
end



