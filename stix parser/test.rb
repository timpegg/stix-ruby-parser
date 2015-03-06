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
#Dir.chdir 'C:\Users\tpegg\Desktop\privilege'
#
#@files.grep(/(.*)[Ss][Tt][Ii][Xx](.*)/).each do | file |
#  puts file
#end
#
#@files = Dir.entries('C:\Users\tpegg\Desktop\privilege').select {|entry| File.directory? File.join('/your_dir',entry) and !(entry =='.' || entry == '..') }
#
#  puts "****************Dir Test**************************"
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

puts "****************StixParser Test**************************"
require 'json'
require 'date'
require 'nokogiri-test.rb'

@theonering_hash = Hash.new()

@working_dir = 'C:\Users\tpegg\Desktop\privilege'

Dir.chdir @working_dir

@files = Dir.entries(@working_dir).select {|f| !File.directory? f}

@files.grep(/(.*)[Ss][Tt][Ii][Xx](.*)/).each do | file |

  @parser = StixParser.new(file)
  @parser_hash = @parser.parse()

  @parser_hash.each do | k,v|
    @theonering_hash[k]=[v]
  end

end

puts @json_text = JSON.pretty_generate(@theonering_hash)

#puts "****************JSON Test**************************"
#
#require 'json'
#require 'date'
#
##string = '{"urls":{"url":"1234","kill_chain_name":"c2","date":"03/04/2014"},"domain names":{"domain name":"DNS_Value","delivery":"kill_chain_valuse","date":"03/04/2014"}}'
##parsed = JSON.parse(string) # returns a hash
##
##p parsed["urls"]["url"]
##p parsed["domain names"]
#
#@key_string = "test.com"
#@testhash = {}
#@testhash[@key_string] = ["c2", Time.parse('2014-11-22T21:23:30Z') ]
#@key_string = "bash.com"
#@testhash[@key_string] = ["c2", Time.parse('2014-11-21T21:23:30Z')]
#@key_string = "joho.com"
#@testhash[@key_string] = ["c2", Time.parse('2014-11-20T21:23:30Z')]
#@testhash[@key_string] = ["delivery","3/14/15"]
#@testhash[@key_string] = ["c2","3/16/15"]
#@testhash[@key_string] = ["c2",Time.parse('2015-11-19T21:23:30Z')]
#@key_string = "test.com"
#@testhash[@key_string] = ["c2",Time.parse('2016-11-18T21:23:30Z')]
#@key_string = "test2.com"
#@testhash[@key_string] = ["delivery",Time.parse('2017-11-17T21:23:30Z')]
#
#@testhash.each do | k,v|
#  puts "#{k}:#{v}"
#end
#
#puts @json_text = JSON.pretty_generate(@testhash)
#
#@new_hash = JSON.parse(@json_text)
#
#
##@new_hash.each do | k,v|
##  @parsed_hash[k] = v if Time.parse(v[1]).to_date <= Date.today
##end
#
#parsed_hash = Hash.new
#@new_hash.each do | pair|
#  parsed_hash.store(pair[0], pair[1]) if Time.parse(pair[1][1]).to_date >= Date.today
#end
#
#parsed_hash.each do | k,v|
#  puts "#{k}:#{v}"
#end
#
#
### Read JSON from a file, iterate over objects
##file = open("shops.json")
##json = file.read
##
##parsed = JSON.parse(json)
##
##parsed["shop"].each do |shop|
##  p shop["id"]
##end
#
#puts "****************JSON Test END**************************"

