class AddressObjType
  def initialize( attribute={:category=>nil, :is_source=>nil, :is_destination=>nil, :is_spoofed=>nil}, address_value=nil, vlan_name = nil, vlan_num = nil)
    # This checks for all the attributes that we need.
    raise "wrong type: attribute must have a category key" unless attribute.has_key?(:category)
    raise "wrong type: attribute must have a is_source key" unless attribute.has_key?(:is_source)
    raise "wrong type: attribute must have a is_destination key" unless attribute.has_key?(:is_destination)
    raise "wrong type: attribute must have a is_spoofed key" unless attribute.has_key?(:is_spoofed)
    @attribute = attribute
    @address_value = address_value
    @vlan_name = vlan_name
    @vlan_num = vlan_num
  end # End initialize
  
  def to_s
    string_value = "attribute{"
    @attribute.each { |k, v| string_value << " #{k}: #{v}," } 
    string_value << "}, address_value #@address_value, vlan_name #@vlan_name, vlan_num #@vlan_num"
    string_value
  end # End to_s
  
  attr_reader :address_value;
  attr_reader :vlan_name;
  attr_reader :vlan_num;
  
  def get_category
    @attribute[:category]
  end
  
  def is_source?
    @attribute[:is_source]
  end
  
  def is_destination?
    @attribute[:is_destination]
  end
  
  def is_spoofed?
    @attribute[:is_spoofed]
  end
  
end # End AddressObj