class StixTypeObj
  def initialize( id=nil, idref=nil, timestamp=nil, version=nil, arrayOfStixTypeObj=nil)
    @id=id
    @idref=idref
    @timestamp=timestamp
    @arrayOfStixTypeOj=arrayOfStixTypeObj
  end # End initialize

  def to_s
    "#@id, #@idref, #@timestamp, #@version, [ " + @arrayOfStixTypeOj.join(" ") + " ]"
  end # End to_s

end # End StixTypeObj

class StixHeaderType < StixTypeObj
  def initialize(arrayOfStixHeaderType = nil)
    super(nil, nil, nil, nil, arryaOfStixHeaderType)
  end # End initialize

end # End StixHeaderType


class StixInformationSouce < StixTypeObj
  def initialize ()
  end
end # End StixInformationSouce

class ObservablesType < StixTypeObj
  def initialize(cybox_major_version = nil, cybox_minor_version = nil, cybox_update_version = nil,  observables = nil)
    @cybox_major_version = cybox_major_version
    @cybox_minor_version = cybox_minor_version
    @cybox_update_version = cybox_update_version
    @observables = observables
  end
end # End ObservablesType





################  OLD STIX IMP ##################################S

class StixType
  def initialize(typeOfStix = nil)
    @typeOfStix = typeOfStix
  end # End initialize

end # End StixType



class StixTitleType < StixType
  def initialize(title = nil)
    super(typeOfStix = "StixTitleType")
    @title = title
  end # End initialize

  def to_s
    "#@typeOfStixm, #@title"
  end # End to_s

end # End StixTitleType

class StixIndicators < StixType
  def initialize(arrayOfStixIndicators= nil)
    super(typeOfStix = "StixIndicators")
    @arrayOfIndicators = arrayOfStixIndicators
  end # End initialize

end # End StixIndicators

class StixIndicator < StixType
  def initialize(id = nil, version= nil, xsiType= nil, arrayOfIndicator= nil)
    super(typeOfStix = "StixIndicator")
    @id = id
    @version = version
    @xsiType = xsiType
    @arrayOfIndicators = arrayOfIndicator
  end # End initialize

end # End StixIndicator

