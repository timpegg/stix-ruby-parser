require 'json'

require_relative '..\ewinparser'
require 'date'

module Ewinparser
  class Ewinstore
    attr_reader :ewin_store_hash, :removed_hash, :added_hash

    @ewin_store_hash = Hash.new
    @remove_hash = Hash.new
    @added_hash = Hash.new
    def self.import(file)

      @file = open(file)
      @json = @file.read

      @ewin_store_hash = JSON.parse(@json)

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

    def self.cull_ips(days)
    end

    def self.cull(days: 365, emails: false, ips: false, domains: false )

      @culldate = Date.today - days
      @output = Hash.new()

      Ewinparser.logger.debug "ewinstore::cull Start"
      Ewinparser.logger.info  "ewinstore::cull removing entries older than #{days} old"

      if (emails or ips or domains)
        @ewin_store_hash.each do |k,v|
          # count the ones that are older than days
          if (Date.parse(v[3]) < @culldate)
            if emails
              if k.include?("@")
                Ewinparser.logger.debug  "ewinstore::cull removing: %s: %s" % [k,v]
                @remove_hash[k] = v
              end
            end
            if ips
              if k =~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/
                Ewinparser.logger.debug  "ewinstore::cull removing: %s: %s" % [k,v]
                @remove_hash[k] = v
              end
            end
            if domains
              if (k =~ /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}/ and !k.include?('@'))
                Ewinparser.logger.debug  "ewinstore::cull removing: %s: %s" % [k,v]
                @remove_hash[k] = v
              end
            end
          else
            Ewinparser.logger.debug  "ewinstore::cull keeping: %s: %s" % [k,v]
            @output[k] = v
          end

          @ewin_store_hash = @output

        end
      end
      Ewinparser.logger.debug "ewinstore::cull End"

    end

    def self.add_hash(hash)
      @new_hash = hash
      @new_hash.each do |k,v|
        if !@ewin_store_hash.has_key?(k)
          @added_hash[k] = v
        end
        @ewin_store_hash[k] = v
      end
    end

    def self.find_ips(hash)
      @out_array = Array.new
      @input_hash = hash
      @input_hash.each do |k,v|
        if k =~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/
          @out_array.push(k)
        end
      end
      @out_array

    end

    def self.get_ips
      find_ips(@ewin_store_hash)
    end

    def self.get_added_ips
      find_ips(@added_hash)
    end

    def self.get_removed_ips
      find_ips(@remove_hash)
    end

    def self.find_domains(hash)
      @out_array = Array.new
      @input_hash = hash
      @input_hash.each do |k,v|
        if (k =~ /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}/ and !k.include?('@'))
          @out_array.push(k)
        end
      end
      @out_array
    end

    def self.get_domains
      find_domains(@ewin_store_hash)
    end

    def self.get_added_domains
      find_domains(@added_hash)
    end

    def self.get_removed_domains
      find_domains(@remove_hash)
    end

    def self.find_emails(hash)
      @out_array = Array.new
      @input_hash = hash
      @input_hash.each do |k,v|
        if k.include?("@")
          @out_array.push(k)
        end
      end
      @out_array
    end

    def self.get_emails
      find_emails(@ewin_store_hash)
    end

    def self.get_added_emails
      find_emails(@added_hash)
    end

    def self.get_removed_emails
      find_emails(@remove_hash)
    end

    def self.ewin_store_length
      @ewin_store_hash.length
    end

  end
end

