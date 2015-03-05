#!/usr/bin/ruby

require 'Indicators.rb'
require 'StixIndicators.rb'
require 'EmailMessageObj.rb'
require 'date'
require 'time'

#
#t =  IndicatorType.new("stixVocabs:IndicatorTypeVocab-1.0", "Domain Watchlist")
#puts t
#
#s =  IndicatorSighting.new(DateTime.now)
#s1 =  IndicatorSighting.new(DateTime.now)
#s2 =  IndicatorSighting.new(DateTime.now)
#puts s
#puts s1
#puts s2
#puts "+++++++++++++++++++++++++++++++++++++++++++"
#data = [ s, s1, s2]
#
#data.each do | tmp |
#  puts tmp
#end
#puts "**************IndicatorSightings****************************"
#
#puts IndicatorSightings.new(3,data).to_s
#
##puts "+++++++++++++++StixHeaderType++++++++++++++++++++++++++++"
##
##puts StixHeaderType.new("blah","description", nil , nil,"Safety","Good").to_s
#
#puts "***************AddressObjType***************************"
#
##  attribute={:category=>nil, :is_source=>nil, :is_destination=>nil, :is_spoofed=>nil}, address_value=nil, vlan_name = nil, vlan_num = nil)
#attribute = {}
#attribute[:category]  = "ip"
#attribute[:is_source] = "true"
#attribute[:is_destination] = "false"
#attribute[:is_spoofed] = "true"
#  
#puts AddressObjType.new(attribute, "10.0.0.1", nil, nil).to_s
#
#addressobj =  AddressObjType.new(attribute, "10.0.0.1", nil, nil)
#puts addressobj.get_category()
#puts addressobj.is_source?()
#puts addressobj.is_spoofed?()
#puts addressobj.is_destination?()
#puts addressobj.address_value()
#
#
#
#puts "****************StixTypeObj**************************"
#
#tempStixTypeObj = StixTypeObj.new("123","ref","12/31/2014","1.2", data)
#puts tempStixTypeObj.to_s
#puts tempStixTypeObj.class.name
#puts "****************Dir Test**************************"
#
#@files = Dir.entries("C:\\Users\\tpegg\\Desktop\\privilege").select {|f| !File.directory? f}
#  
#@files.grep(/(.*)[Ss][Tt][Ii][Xx](.*)/).each do | file |
#  puts file
#end

## 'C:\Users\tpegg\Desktop\privilege\MIFR-407235_stix.xml'


#puts StixHeaderType.new("My Stix Title", "New Description").to_s

##time = Time.now.getutc
##puts time.inspect
#
#puts "UTC: " + Time.parse('2014-11-17T21:23:30Z').inspect
#
#puts "Local: " + Time.parse('2014-11-17T21:23:30Z').localtime.inspect
#
#
#

#puts "****************StixParser Test**************************"
#require 'nokogiri-test.rb'
#
#@parser = StixParser.new('C:\Users\tpegg\Desktop\privilege\IB-15-10057.STIX.xml')
#@parser.parse()
#

puts "****************JSON Test**************************"

require 'json'
#string = '{"urls":{"url":"1234","kill_chain_name":"c2","date":"03/04/2014"},"domain names":{"domain name":"DNS_Value","delivery":"kill_chain_valuse","date":"03/04/2014"}}'
#parsed = JSON.parse(string) # returns a hash
#
#p parsed["urls"]["url"]
#p parsed["domain names"]

@key_string = "test.com"  
@testhash = {}
@testhash[@key_string] = ["c2","3/4/5"]
@key_string = "bash.com"  
@testhash[@key_string] = ["c2","3/4/5"]
@key_string = "joho.com"  
@testhash[@key_string] = ["c2","3/4/5"]
@key_string = "test.com"  
@testhash[@key_string] = ["c2","3/4/15"]

@testhash.each do | k,v|
  puts "#{k}:#{v}"
end

puts @json_text = JSON.pretty_generate(@testhash)

  
## Read JSON from a file, iterate over objects
#file = open("shops.json")
#json = file.read
#
#parsed = JSON.parse(json)
#
#parsed["shop"].each do |shop|
#  p shop["id"]
#end

puts "****************JSON Test END**************************"





