require 'json'

require_relative '..\ewinparser'
require 'date'

module Ewinparser
  class Ewinstore
    attr_reader :ewin_store_hash
    @ewin_store_hash = Hash.new
    def self.import(file)

      @file = open(file)
      @json = @file.read

      @ewin_store_hash  = JSON.parse(@json)

      Ewinparser.logger.debug "ewinstore::open Start"
      Ewinparser.logger.info  "ewinstore::open Reading #{file}"
      if Ewinparser.logger.debug?
        @ewin_store_hash.each do | k,v |
          Ewinparser.logger.debug  "ewinstore::open Parsed: %-25s  %25s" % [k, v]
        end
      end

      Ewinparser.logger.debug "ewinstore::open End"
    end

    # This is the file used as the database.  If the file is empty then the script generates a new database.
    # TODO Create an entry for the JSONFile that has the some file meta data information. Need to think if there is any useful information for this header.
    # TODO If the file is nil then write to STDOUT.
    def self.export(file)
      @file = open(file,"w")

      Ewinparser.logger.debug "ewinstore::save Start"
      Ewinparser.logger.info  "ewinstore::save Writing to #{file}"

      @file.write(JSON.pretty_generate(@ewin_store_hash))

      if Ewinparser.logger.debug?
        @ewin_store_hash.each do |k,v|
          Ewinparser.logger.debug "ewinstore::save entry: %s: %s" % [k,v]
        end
      end

      Ewinparser.logger.debug "ewinstore::save End"

    end

    def self.cull(days)

      @culldate = Date.today - days
      @output = Hash.new()

      Ewinparser.logger.debug "ewinstore::cull Start"
      Ewinparser.logger.info  "ewinstore::cull removing entries older than #{days} old"

      @ewin_store_hash.each do |k,v|
        # count the ones that are older than days
        if (Date.parse(v[3]) < @culldate)
          Ewinparser.logger.debug  "ewinstore::cull removing: %s: %s" % [k,v]
        else
          Ewinparser.logger.debug  "ewinstore::cull keeping: %s: %s" % [k,v]
          @output[k] = v
        end

        @ewin_store_hash = @output

        #      puts "OUTPUT: #{k} : #{v}" if (DateTime.strptime(v) < @lastyear)
      end
      Ewinparser.logger.debug "ewinstore::cull End"

    end

    def self.add_hash(hash)
      @new_hash = hash
      @new_hash.each do |k,v|
        @ewin_store_hash[k] = v
      end
    end

    def self.ewin_store_length
      @ewin_store_hash.length
    end

  end
end

