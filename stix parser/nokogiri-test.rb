require 'open-uri'
require 'nokogiri'
require 'pp'
require 'logger'
require 'time'
require 'json'


class StixParser
  @array_of_indicators = []
  def initialize(xml_file_name)
    @xml_file_name = xml_file_name
  end

  def parse()

    # TODO:  Need to account for <cybox:Observable_Composition operator="AND"> to parse out additional IP addresses.
    # 'C:\Users\tpegg\Desktop\privilege\IB-15-20005.stix.xml'

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

    # file_name = 'C:\Users\tpegg\Desktop\privilege\MIFR-421835-A_stix.xml'

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
      $observable_item = nil;
      $kill_chain_name = nil;
      
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
                                             ./cybox:Properties[@category="ipv4-addr"]  |
                                             ./cybox:Properties[@type="URL"] |
                                             ./cybox:Properties[@type="Domain Name"]
                                            ')

          @cybox_properties.each do |cybox_property |
            logger.debug "%-18s %s" % [ "   cybox:Properties [Path]:" , cybox_property.path ]
            logger.debug "%-18s %s" % [ "   cybox:Properties [Name]:" , cybox_property.name ]

            if cybox_property.namespaces.has_key?('xmlns:DomainNameObj')
              logger.debug "   cybox:Properties Note: Has namespace xmlns:DomainNameObj"
              @domainnameobjs = cybox_property.search('./DomainNameObj:Value')

              @domainnameobjs.each do | domainnameobj |
                logger.debug "%-18s %s" % [ "    DomainNameObj:Value [Path]:" , domainnameobj.path ]
                logger.debug "%-18s %s" % [ "    DomainNameObj:Value [Name]:" , domainnameobj.name ]
                logger.info "%-18s %s" % [ "    DomainNameObj:Value [Content]:" , domainnameobj.content ]
                $observable_item = domainnameobj.content
                $observable_type = "domain name"
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
                $observable_item = uriobj_value.content
                $observable_type = "url"

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
                $observable_item = addrobj_address_values.content
                $observable_type = "ipv4-addr"
                
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
                    $observable_item = addrobj_address_value.content
                    $observable_type = "e-mail"
                    
                  end # End addrobj_address_values.each

                end # End emailmessageobj_senders

              end # End email_message_headers.each

            else
              logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:EmailMessageObj"
            end # End cybox_property.namespaces.has_key?

          end # End cybox_properties.each

        end # End cybox_objects.each

      end # End indicator_observables.each

      if !$observable_item.nil?
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
            logger.debug "%-18s %s" % [ "  stixCommon:Kill_Chain_Phase [Path]:" , stixcommon_kill_chain_phase.path ]
            logger.debug "%-18s %s" % [ "  stixCommon:Kill_Chain_Phase [Name]:" , stixcommon_kill_chain_phase.name ]
            logger.info "%-18s %s" % [ "  stixCommon:Kill_Chain_Phase [attribute(name)]:" , stixcommon_kill_chain_phase.attribute('name') ]
            logger.info "%-18s %s" % [ "  stixCommon:Kill_Chain_Phase [attribute(ordinality)]:" , stixcommon_kill_chain_phase.attribute('ordinality') ]
            
            $kill_chain_name = stixcommon_kill_chain_phase.attribute('name')
            
            
            puts $observable_type + " : " + $observable_item + " : " + $kill_chain_name  + " : " +  Time.now.to_s
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
    logger.info  "Parser complete"
    logger.info "#"*line_padding

  end #End Parse

end # End StixParser

