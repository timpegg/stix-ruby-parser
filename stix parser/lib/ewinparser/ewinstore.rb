require 'json'

require_relative '..\ewinparser'
require 'date'

module Ewinparser
  class Ewinstore
    EMAIL     = 0b001
    WEBFILTER = 0b010
    FIREWALL  = 0b100
    ALLCLEAR  = 0b000

    ip_search_string = '\b(?:\d{1,3}\.){3}\d{1,3}\b'
    domain_search_string = '[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}'
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

    def self.cull(days)

      @culldate = Date.today - days
      @output = Hash.new()

      Ewinparser.logger.debug "ewinstore::cull Start"
      Ewinparser.logger.info  "ewinstore::cull removing entries older than #{days} old"

      @ewin_store_hash.each do |k,v|
        # count the ones that are older than days
        if (Date.parse(v[3]) < @culldate)
          Ewinparser.logger.debug  "ewinstore::cull removing: %s: %s" % [k,v]
          # check to see if the firewall flag is set
          if (v[1].to_s(2) & FIREWALL) == FIREWALL
            # clear the firewall flag so we don't report on this the next go round.
            @output[k][1] = (v[1].to_s(2) ^ FIREWALL)
          end
          @remove_hash[k] = v
        else
          Ewinparser.logger.debug  "ewinstore::cull keeping: %s: %s" % [k,v]
          @output[k] = v
        end

        @ewin_store_hash = @output

      end
      Ewinparser.logger.debug "ewinstore::cull End"

    end

    def self.cull_webfilter(days)

      @culldate = Date.today - days
      @output = Hash.new()

      Ewinparser.logger.debug "ewinstore::cull_webfilter Start"
      Ewinparser.logger.info  "ewinstore::cull_webfilter removing entries older than #{days} old"

      @ewin_store_hash.each do |k,v|
        # count the ones that are older than days and it's in WEBFILTER
        if ((Date.parse(v[3]) < @culldate) and (v[1].to_s(2) & WEBFILTER))
          Ewinparser.logger.debug  "ewinstore::cull_webfilter removing: %s: %s" % [k,v]
        else
          Ewinparser.logger.debug  "ewinstore::cull_webfilter keeping: %s: %s" % [k,v]
          @output[k] = v
        end

        @ewin_store_hash = @output

      end
      Ewinparser.logger.debug "ewinstore::cull_webfilter End"

    end

    def self.add_hash(hash)
      @new_hash = hash
      @new_hash.each do |k,v|
        if k =~ /#{ip_search_string}/
          # set the  firewall and webfilter flag
          v[1] = (WEBFILTER | FIREWALL)
        elsif k.include?("@")
          # Found an @ so set the email flag
          v[1] = EMAIL
        else
          # Found a domain and add webfilter flag only.
          v[1] = WEBFILTER
        end
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
        if k =~ /#{ip_search_string}/
          @out_array.push(k)
        end
      end
      @out_array

    end

    def self.get_ips
      find_ips(@ewin_store_hash)
    end

    def self.get_webfilter_ips
      ip_hash = find_ips(@ewin_store_hash)
      return_hash = Hash.new()
      ip_hash.each{ | k,v |
        if ((v[1].to_s(2) & WEBFILTER) == WEBFILTER)
          return_hash[k]=v
        end
      }
      return_hash
    end

    def self.get_firewall_ips
      ip_hash = find_ips(@ewin_store_hash)
      return_hash = Hash.new()
      ip_hash.each{ | k,v |
        if ((v[1].to_s(2) & FIREWALL) == FIREWALL)
          return_hash[k]=v
        end
      }
      return_hash
    end

    def self.get_added_ips
      find_ips(@added_hash)
    end

    def self.get_removed_ips
      find_ips(@remove_hash)
    end

    def self.get_removed_fw_ips
      find_ips(@remove_hash)
    end

    def self.find_domains(hash)
      @out_array = Array.new
      @input_hash = hash
      @input_hash.each do |k,v|
        if (k =~ /#{domain_search_string}/ and !k.include?('@'))
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

