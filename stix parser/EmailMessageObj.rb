require 'AddressObjType.rb'

class EmailMessageObj
  def initialize(arrayOfEmailMessageObjType = nil)
    @arrayOfEmailMessageObjType = arrayOfEmailMessageObjType
  end # End initialize

end # End EmailMessageObj

class EmailMessageHeaderType < EmailMessageObj
  def initialize(arrayOfEmailMessageHeadderObj = nil)
    @arrayOfEmailMessageHeadderObj = arrayOfEmailMessageHeaderObj
  end # End initialize

end # End EmailMessageHeaderType

class EmailMessageSenderObj < EmailMessageObj
  def initialize(addrObj = nil)
    @addrObj = addrObj
  end # End initialize

end # End CyboxEmailMessageSenderObj

class EmailMessageFrom < EmailMessageObj
  def initilize(addrObj = nil)
    @addrObj = addrObj
  end
end

