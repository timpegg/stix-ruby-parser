class StixType
end


class StixTypeObj < StixType
  def initialize( array_of_stix, id=nil, idref=nil, timestamp=nil, version=nil )
    @id=id
    @idref=idref
    @timestamp=timestamp
    @array_of_stix=array_of_stix
  end # End initialize

  def to_s
    "#@id, #@idref, #@timestamp, #@version, [ " + @array_of_stix.join(" ") + " ]"
  end # End to_s

end # End StixTypeObj


class StixHeaderType < StixTypeObj
  def initialize(title=nil, description=nil, time_date_stamp=nil)
    raise "StixHeaderType wrong type: title must be a String or Nil" unless (title.is_a?(String)  | title.nil?)
    raise "StixHeaderType wrong type: description must be a String or Nil" unless (description.is_a?(StructuredTextType)  | description.nil?)
    @title = title
    @description = description
    @information_source = information_source
  end
  
  def to_s
    "#@title"
  end
end # End StixHeaderType


class  StructuredTextType < StixType
  def initialize(string = nil, array_of_attributes = nil)
    raise "StructuredTextType wrong type: string must be a String or Nil" unless (string.is_a?(String)  | string.nil?)
    raise "StructuredTextType wrong type: array_of_attributes must be an Array or Nil" unless (array_of_attributes.is_a?(Array)  | array_of_attributes.nil?)
    @string = string
    @array_of_attributes = array_of_attributes
    
  end
  
  def to_s
    "#@string, " +  @array_of_attributes.join(" ")
  end
  
end # End StructuredTextType

class StixStructuredTextType < StixType
  
end

class StixDescription < StixStructuredTextType
  def initialize(description = nil)
      raise "StixDescription wrong type: description must be a String" unless (description.is_a?(String)  | description.nil?)
      @description = description;
  end # End initialize

  def to_s
    "Description: #@description"
  end # End to_s

end # End StixDescription

class StixShortDescription < StixHeaderType
  def initialize(short_description = nil)
      raise "StixShortDescription wrong type: short_description must be a String" unless (short_description.is_a?(String)  | short_description.nil?)
      @short_description = short_description;
  end # End initialize

  def to_s
    "Short Description: #@short_description"
  end # End to_s

end # End StixShortDescription




class ObservablesType < StixTypeObj
  def initialize(array_of_observable, cybox_major_version = nil, cybox_minor_version = nil, cybox_update_version = nil )
    @cybox_major_version = cybox_major_version
    @cybox_minor_version = cybox_minor_version
    @cybox_update_version = cybox_update_version
    @observables = observables
  end
  
end # End ObservablesType

