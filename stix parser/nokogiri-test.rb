require 'open-uri'
require 'nokogiri'
require 'pp'
require 'logger'
require 'time'
require 'json'


#TODO Review the LinkObj to determine if we need to check for URL_Label conditions.  For example the uri may show adobe.com but the link goes to evildomain.com


class StixParser
  @array_of_indicators = []
  def initialize(xml_file_name)
    @xml_file_name = xml_file_name
  end
  
  def parse()

    @xml_file_name_comp = File.basename @xml_file_name
    @results_hash = Hash.new

    line_padding = 80
    logger = Logger.new($stdout)
    logger.level = Logger::WARN
#    logger.level = Logger::INFO
#    logger.level = Logger::DEBUG
    logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    logger.formatter = lambda do |severity, datetime, progname, msg|
      #  "#{datetime}:#{progname}: #{severity}: #{msg}\n"
      "StixParser: %-5s: %10s\n" % [ severity, msg]
    end

    @xml_file = File.open(@xml_file_name,'r')
    @doc = Nokogiri::XML(@xml_file)

    logger.info "#"*line_padding
    logger.info "File Name: " + @xml_file_name
    logger.info "#"*line_padding
    @doc.collect_namespaces.each do | key,value |
      logger.debug  "XML NameSpaces: " + "%-10s  %10s" % [ key, value]
    end
    logger.debug "#"*line_padding

    # this sets the path for just the Indicator nodes.
    @stix_indicators = @doc.xpath('/stix:STIX_Package/stix:Indicators/stix:Indicator')

    @stix_indicators.each do |stix_indicator|

      logger.debug "%-18s %s" % [ "Stix:Indicator [Path]:" , stix_indicator.path ]
      logger.debug "%-18s %s" % [ "Stix:Indicator [Name]:" , stix_indicator.name ]
      logger.debug "%-18s %s" % [ "Stix:Indicator [@id]:"  , stix_indicator.attribute("id") ]

      # These will be the output for each node as applicable.
      @observable_item = nil;
      @kill_chain_name = nil;
      
      @indicator_observables = stix_indicator.search('./indicator:Observable')

      @indicator_observables.each do |indicator_observable|
        logger.debug "%-18s %s" % [ " Indicator:Observable [Path]:" , indicator_observable.path ]
        logger.debug "%-18s %s" % [ " Indicator:Observable [Name]:" , indicator_observable.name ]
        logger.debug "%-18s %s" % [ " Indicator:Observable [@id]:"  , indicator_observable.attribute("id") ]

        @cybox_objects = indicator_observable.search('./cybox:Object')

        @cybox_objects.each do | cybox_object |
          logger.debug "%-18s %s" % [ "  cybox:Object [Path]:" , cybox_object.path ]
          logger.debug "%-18s %s" % [ "  cybox:Object [Name]:" , cybox_object.name ]
          logger.debug "%-18s %s" % [ "  cybox:Object [@id]:"  , cybox_object.attribute("id") ]

          # This searches for Email messages, ipv4-addr, URLs,
          @cybox_properties=cybox_object.search('./cybox:Properties[@xsi:type="EmailMessageObj:EmailMessageObjectType"]   |
                                                 ./cybox:Properties[@xsi:type="AddressObj:AddressObjectType"]  |
                                                 ./cybox:Properties[@xsi:type="LinkObj:LinkObjectType"] |
                                                 ./cybox:Properties[@xsi:type="URIObj:URIObjectType"]
                                            ')

          @cybox_properties.each do |cybox_property |
            logger.debug "%-18s %s" % [ "   cybox:Properties [Path]:" , cybox_property.path ]
            logger.debug "%-18s %s" % [ "   cybox:Properties [Name]:" , cybox_property.name ]
            @observable_type_hash = cybox_property.attributes;
            logger.debug "%-18s %s" % [ "   cybox:Properties [xsi:type]:" , cybox_property["xsi:type"].to_s.gsub(/(.*):(.*)/, '\1') ]
            @observable_type = cybox_property["xsi:type"].to_s.gsub(/(.*):(.*)/, '\1')
            
            if cybox_property.namespaces.has_key?('xmlns:DomainNameObj')
              logger.debug "   cybox:Properties Note: Has namespace xmlns:DomainNameObj"
              @domainnameobjs = cybox_property.search('./DomainNameObj:Value')

              @domainnameobjs.each do | domainnameobj |
                logger.debug "%-18s %s" % [ "    DomainNameObj:Value [Path]:" , domainnameobj.path ]
                logger.debug "%-18s %s" % [ "    DomainNameObj:Value [Name]:" , domainnameobj.name ]
                logger.info "%-18s %s" % [ "    DomainNameObj:Value [Content]:" , domainnameobj.content ]
                @observable_item = domainnameobj.content
                #@observable_type = domainnameobj.name.to_s
              end # End domainnameobjs.each

            else
              logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:DomainNameObj"
            end # End cybox_property.namespaces.has_key?

            if cybox_property.namespaces.has_key?('xmlns:URIObj')
              logger.debug "   cybox:Propertie Note: Has namespace xmlns:URIObj"

              @uriobj_values = cybox_property.search('./URIObj:Value[@condition="Equals"]')

              @uriobj_values.each do | uriobj_value |
                logger.debug "%-18s %s" % [ "    URIObj:Value [Path]:" , uriobj_value.path ]
                logger.debug "%-18s %s" % [ "    URIObj:Value [Name]:" , uriobj_value.name ]
                logger.info "%-18s %s" % [ "    URIObj:Value [Content]:" , uriobj_value.content ]
                #@observable_item = uriobj_value.content.gsub(/[Hh]([Tt]|[Xx]){2}[Pp]:\/\/(.*?)(\/|:|$)/, '\2')
                @observable_item =  uriobj_value.content
                #@observable_type = uriobj_value.name.to_s

              end # End uriobj_values.each

            else
              logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:URIObj"
            end # End cybox_property.namespaces.has_key?

            if cybox_property.namespaces.has_key?('xmlns:AddressObj')
              logger.debug "   cybox:Propertie Note: Has namespace xmlns:AddressObj"

              @addrobj_address_values = cybox_property.search('./AddrObj:Address_Value[@condition="Equals"]')

              @addrobj_address_values.each do | addrobj_address_values |
                logger.debug "%-18s %s" % [ "    AddrObj:Address_Value [Path]:" , addrobj_address_values.path ]
                logger.debug "%-18s %s" % [ "    AddrObj:Address_Value [Name]:" , addrobj_address_values.name ]
                logger.info "%-18s %s" % [ "    AddrObj:Address_Value [Content]:" , addrobj_address_values.content ]
                @observable_item = addrobj_address_values.content
                #@observable_type = addrobj_address_values.name.to_s
                
              end # End @addrobj_address_values.each

            else
              logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:AddressObj"
            end # End cybox_property.namespaces.has_key?

            if cybox_property.namespaces.has_key?('xmlns:EmailMessageObj')
              logger.debug "   cybox:Propertie Note: Has namespace xmlns:EmailMessageObj"

              @emailmessageobj_headers = cybox_property.search('./EmailMessageObj:Header')

              @emailmessageobj_headers.each do | emailmessageobj_header |
                logger.debug "%-18s %s" % [ "    EmailMessageObj:Header [Path]:" , emailmessageobj_header.path ]
                logger.debug "%-18s %s" % [ "    EmailMessageObj:Header [Name]:" , emailmessageobj_header.name ]

                @emailmessageobj_senders = emailmessageobj_header.search('./EmailMessageObj:Sender[@category="e-mail"]')

                @emailmessageobj_senders.each do | emailmessageobj_sender |
                  logger.debug "%-18s %s" % [ "     EmailMessageObj:Sender [Path]:" , emailmessageobj_sender.path ]
                  logger.debug "%-18s %s" % [ "     EmailMessageObj:Sender [Name]:" , emailmessageobj_sender.name ]

                  @addrobj_address_values = emailmessageobj_sender.search('./AddrObj:Address_Value[@condition="Equals"]')

                  @addrobj_address_values.each do | addrobj_address_value |
                    logger.debug "%-18s %s" % [ "      AddrObj:Address_Value [Path]:" , addrobj_address_value.path ]
                    logger.debug "%-18s %s" % [ "      AddrObj:Address_Value [Name]:" , addrobj_address_value.name ]
                    logger.info "%-18s %s" % [ "      AddrObj:Address_Value [Content]:" , addrobj_address_value.content ]
                    @observable_item = addrobj_address_value.content
                    #@observable_type = addrobj_address_value.name.to_s
                    
                  end # End addrobj_address_values.each

                end # End emailmessageobj_senders

              end # End email_message_headers.each

            else
              logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:EmailMessageObj"
            end # End cybox_property.namespaces.has_key?

          end # End cybox_properties.each

        end # End cybox_objects.each

      end # End indicator_observables.each

      if !@observable_item.nil?
        @indicator_kill_chain_phases = stix_indicator.search('./indicator:Kill_Chain_Phases')

        @indicator_kill_chain_phases.each do | indicator_kill_chan_phase |
          logger.debug "%-18s %s" % [ " Indicator:Kill_Chain_Phases [Path]:" , indicator_kill_chan_phase.path ]
          logger.debug "%-18s %s" % [ " Indicator:Kill_Chain_Phases [Name]:" , indicator_kill_chan_phase.name ]

          @stixcommon_kill_chain_phases = indicator_kill_chan_phase.search('./stixCommon:Kill_Chain_Phase[@name="Exploitation"]           |
                                                                     ./stixCommon:Kill_Chain_Phase[@name="Command and Control"]    |
                                                                     ./stixCommon:Kill_Chain_Phase[@name="Actions on Objectives"]  |
                                                                     ./stixCommon:Kill_Chain_Phase[@name="Delivery"]
                                                                   ')
          @stixcommon_kill_chain_phases.each do | stixcommon_kill_chain_phase |
            logger.debug "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [Path]:" , stixcommon_kill_chain_phase.path ]
            logger.debug "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [Name]:" , stixcommon_kill_chain_phase.name ]
            logger.info "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [attribute(name)]:" , stixcommon_kill_chain_phase.attribute('name') ]
            logger.info "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [attribute(ordinality)]:" , stixcommon_kill_chain_phase.attribute('ordinality') ]
            
            @kill_chain_name = stixcommon_kill_chain_phase.attribute('name').content
            
            
            logger.info "#"*line_padding
            logger.info "%-10s %s" % [ "Found: ", @observable_item + " ::: " + @observable_type + " : " + @kill_chain_name  + " : " + @xml_file_name_comp + " : " + Time.now.to_s ]
            logger.info "#"*line_padding

            @results_hash[@observable_item.downcase] = [@observable_type.downcase, @kill_chain_name.downcase, @xml_file_name_comp.downcase, Time.now.to_s]
            
          end # End stixcommon_kill_chain_phases

        end # End indicator_kill_chan_phases.each

      end # End stix_indicators.each

      
      #  node.attributes do |atr_name,node_attr|
      #    logger.debug "%-15s %-10s %-10s" % [ "Node [Attributes]: ", node.attributes[atr_name] , node_attr.content ]
      #  end
      #  logger.debug "%-10s %s" % [ "Node [Attributes]:" ,  node.inspect ]
    end

    logger.debug "#"*line_padding

    @xml_file.close
    
    logger.info "#"*line_padding
    logger.info "%-10s" % [ "Hash return values:  "]
    logger.info "#"*line_padding
    @results_hash.each do | k,v|
      logger.info "   %15s" % [ "#{k}:#{v}" ]
    end
    logger.info "#"*line_padding
    
    logger.info "#"*line_padding
    logger.info  "Parser complete"
    logger.info "#"*line_padding
    return @results_hash
  end #End Parse

end # End StixParser

