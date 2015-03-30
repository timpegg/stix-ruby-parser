require 'open-uri'
require 'nokogiri'
require 'pp'
require 'logger'
require 'time'
require 'json'

module Ewinparser
  class Stix_parser
    def self.parse(file)

      @xml_file_name = file

      @xml_file_name_comp = File.basename @xml_file_name
      @results_hash = Hash.new

      line_padding = 80

      @xml_file = File.open(@xml_file_name,'r')
      @doc = Nokogiri::XML(@xml_file)

      Ewinparser.logger.info "File Name: " + @xml_file_name
      @doc.collect_namespaces.each do | key,value |
        Ewinparser.logger.debug  "XML NameSpaces: " + "%-10s  %10s" % [ key, value]
      end

      # this sets the path for just the Indicator nodes.
      @stix_indicators = @doc.xpath('/stix:STIX_Package/stix:Indicators/stix:Indicator')

      @stix_indicators.each do |stix_indicator|

        Ewinparser.logger.debug "%-18s %s" % [ "Stix:Indicator [Path]:" , stix_indicator.path ]
        Ewinparser.logger.debug "%-18s %s" % [ "Stix:Indicator [Name]:" , stix_indicator.name ]
        Ewinparser.logger.debug "%-18s %s" % [ "Stix:Indicator [@id]:"  , stix_indicator.attribute("id") ]

        @observable_item = nil;
        @kill_chain_name = nil;

        @indicator_observables = stix_indicator.search('./indicator:Observable')

        @indicator_observables.each do |indicator_observable|
          Ewinparser.logger.debug "%-18s %s" % [ " Indicator:Observable [Path]:" , indicator_observable.path ]
          Ewinparser.logger.debug "%-18s %s" % [ " Indicator:Observable [Name]:" , indicator_observable.name ]
          Ewinparser.logger.debug "%-18s %s" % [ " Indicator:Observable [@id]:"  , indicator_observable.attribute("id") ]

          @cybox_objects = indicator_observable.search('./cybox:Object')

          @cybox_objects.each do | cybox_object |
            Ewinparser.logger.debug "%-18s %s" % [ "  cybox:Object [Path]:" , cybox_object.path ]
            Ewinparser.logger.debug "%-18s %s" % [ "  cybox:Object [Name]:" , cybox_object.name ]
            Ewinparser.logger.debug "%-18s %s" % [ "  cybox:Object [@id]:"  , cybox_object.attribute("id") ]

            # This searches for Email messages, ipv4-addr, URLs,
            @cybox_properties=cybox_object.search('./cybox:Properties[@xsi:type="EmailMessageObj:EmailMessageObjectType"]   |
                                                 ./cybox:Properties[@xsi:type="AddressObj:AddressObjectType"]  |
                                                 ./cybox:Properties[@xsi:type="LinkObj:LinkObjectType"] |
                                                 ./cybox:Properties[@xsi:type="URIObj:URIObjectType"]
                                            ')

            @cybox_properties.each do |cybox_property |
              Ewinparser.logger.debug "%-18s %s" % [ "   cybox:Properties [Path]:" , cybox_property.path ]
              Ewinparser.logger.debug "%-18s %s" % [ "   cybox:Properties [Name]:" , cybox_property.name ]
              @observable_type_hash = cybox_property.attributes;
              Ewinparser.logger.debug "%-18s %s" % [ "   cybox:Properties [xsi:type]:" , cybox_property["xsi:type"].to_s.gsub(/(.*):(.*)/, '\1') ]
              @observable_type = cybox_property["xsi:type"].to_s.gsub(/(.*):(.*)/, '\1')

              if cybox_property.namespaces.has_key?('xmlns:DomainNameObj')
                Ewinparser.logger.debug "   cybox:Properties Note: Has namespace xmlns:DomainNameObj"
                @domainnameobjs = cybox_property.search('./DomainNameObj:Value')

                @domainnameobjs.each do | domainnameobj |
                  Ewinparser.logger.debug "%-18s %s" % [ "    DomainNameObj:Value [Path]:" , domainnameobj.path ]
                  Ewinparser.logger.debug "%-18s %s" % [ "    DomainNameObj:Value [Name]:" , domainnameobj.name ]
                  Ewinparser.logger.debug "%-18s %s" % [ "    DomainNameObj:Value [Content]:" , domainnameobj.content ]
                  @observable_item = domainnameobj.content
                end # End domainnameobjs.each

              else
                Ewinparser.logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:DomainNameObj"
              end # End cybox_property.namespaces.has_key?

              if cybox_property.namespaces.has_key?('xmlns:URIObj')
                Ewinparser.logger.debug "   cybox:Propertie Note: Has namespace xmlns:URIObj"

                @uriobj_values = cybox_property.search('./URIObj:Value[@condition="Equals"]')

                @uriobj_values.each do | uriobj_value |
                  Ewinparser.logger.debug "%-18s %s" % [ "    URIObj:Value [Path]:" , uriobj_value.path ]
                  Ewinparser.logger.debug "%-18s %s" % [ "    URIObj:Value [Name]:" , uriobj_value.name ]
                  Ewinparser.logger.debug "%-18s %s" % [ "    URIObj:Value [Content]:" , uriobj_value.content ]
                  @observable_item =  uriobj_value.content

                end # End uriobj_values.each

              else
                Ewinparser.logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:URIObj"
              end # End cybox_property.namespaces.has_key?

              if cybox_property.namespaces.has_key?('xmlns:AddressObj')
                Ewinparser.logger.debug "   cybox:Propertie Note: Has namespace xmlns:AddressObj"

                @addrobj_address_values = cybox_property.search('./AddrObj:Address_Value[@condition="Equals"]')

                @addrobj_address_values.each do | addrobj_address_values |
                  Ewinparser.logger.debug "%-18s %s" % [ "    AddrObj:Address_Value [Path]:" , addrobj_address_values.path ]
                  Ewinparser.logger.debug "%-18s %s" % [ "    AddrObj:Address_Value [Name]:" , addrobj_address_values.name ]
                  Ewinparser.logger.debug "%-18s %s" % [ "    AddrObj:Address_Value [Content]:" , addrobj_address_values.content ]
                  @observable_item = addrobj_address_values.content

                end # End @addrobj_address_values.each

              else
                Ewinparser.logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:AddressObj"
              end # End cybox_property.namespaces.has_key?

              if cybox_property.namespaces.has_key?('xmlns:EmailMessageObj')
                Ewinparser.logger.debug "   cybox:Propertie Note: Has namespace xmlns:EmailMessageObj"

                @emailmessageobj_headers = cybox_property.search('./EmailMessageObj:Header')

                @emailmessageobj_headers.each do | emailmessageobj_header |
                  Ewinparser.logger.debug "%-18s %s" % [ "    EmailMessageObj:Header [Path]:" , emailmessageobj_header.path ]
                  Ewinparser.logger.debug "%-18s %s" % [ "    EmailMessageObj:Header [Name]:" , emailmessageobj_header.name ]

                  @emailmessageobj_senders = emailmessageobj_header.search('./EmailMessageObj:Sender[@category="e-mail"]')

                  @emailmessageobj_senders.each do | emailmessageobj_sender |
                    Ewinparser.logger.debug "%-18s %s" % [ "     EmailMessageObj:Sender [Path]:" , emailmessageobj_sender.path ]
                    Ewinparser.logger.debug "%-18s %s" % [ "     EmailMessageObj:Sender [Name]:" , emailmessageobj_sender.name ]

                    @addrobj_address_values = emailmessageobj_sender.search('./AddrObj:Address_Value[@condition="Equals"]')

                    @addrobj_address_values.each do | addrobj_address_value |
                      Ewinparser.logger.debug "%-18s %s" % [ "      AddrObj:Address_Value [Path]:" , addrobj_address_value.path ]
                      Ewinparser.logger.debug "%-18s %s" % [ "      AddrObj:Address_Value [Name]:" , addrobj_address_value.name ]
                      Ewinparser.logger.debug "%-18s %s" % [ "      AddrObj:Address_Value [Content]:" , addrobj_address_value.content ]
                      @observable_item = addrobj_address_value.content

                    end # End addrobj_address_values.each

                  end # End emailmessageobj_senders

                end # End email_message_headers.each

              else
                Ewinparser.logger.debug "   cybox:Propertie Note: Doesn't have namespace xmlns:EmailMessageObj"
              end # End cybox_property.namespaces.has_key?

            end # End cybox_properties.each

          end # End cybox_objects.each

        end # End indicator_observables.each

        if !@observable_item.nil?
          @indicator_kill_chain_phases = stix_indicator.search('./indicator:Kill_Chain_Phases')

          @indicator_kill_chain_phases.each do | indicator_kill_chan_phase |
            Ewinparser.logger.debug "%-18s %s" % [ " Indicator:Kill_Chain_Phases [Path]:" , indicator_kill_chan_phase.path ]
            Ewinparser.logger.debug "%-18s %s" % [ " Indicator:Kill_Chain_Phases [Name]:" , indicator_kill_chan_phase.name ]

            @stixcommon_kill_chain_phases = indicator_kill_chan_phase.search('./stixCommon:Kill_Chain_Phase[@name="Exploitation"]           |
                                                                     ./stixCommon:Kill_Chain_Phase[@name="Command and Control"]    |
                                                                     ./stixCommon:Kill_Chain_Phase[@name="Actions on Objectives"]  |
                                                                     ./stixCommon:Kill_Chain_Phase[@name="Delivery"]
                                                                   ')
            @stixcommon_kill_chain_phases.each do | stixcommon_kill_chain_phase |
              Ewinparser.logger.debug "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [Path]:" , stixcommon_kill_chain_phase.path ]
              Ewinparser.logger.debug "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [Name]:" , stixcommon_kill_chain_phase.name ]
              Ewinparser.logger.debug "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [attribute(name)]:" , stixcommon_kill_chain_phase.attribute('name') ]
              Ewinparser.logger.debug "  %18s %s" % [ "stixCommon:Kill_Chain_Phase [attribute(ordinality)]:" , stixcommon_kill_chain_phase.attribute('ordinality') ]

              @kill_chain_name = stixcommon_kill_chain_phase.attribute('name').content

              Ewinparser.logger.debug "%-10s %s" % [ "Found: ", @observable_item.downcase + " ::: " + @observable_type.downcase + " : " + @kill_chain_name.downcase  + " : " + @xml_file_name_comp.downcase + " : " + Time.now.to_s ]

              @results_hash[@observable_item.downcase] = [@observable_type.downcase, @kill_chain_name.downcase, @xml_file_name_comp.downcase, Time.now.to_s]

            end # End stixcommon_kill_chain_phases

          end # End indicator_kill_chan_phases.each

        end # End stix_indicators.each

      end

      @xml_file.close

      Ewinparser.logger.info "%-10s" % [ "Hash return values:  "]
      @results_hash.each do | k,v|
        Ewinparser.logger.info "   %15s" % [ "#{k}:#{v}" ]
      end

      Ewinparser.logger.info  "Parser complete"

      @results_hash

    end

  end

end

