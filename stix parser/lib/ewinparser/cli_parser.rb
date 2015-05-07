require 'optparse'
require 'singleton'
require 'logger'

# Command line option parser
module Ewinparser

  ConfigurtionStruct = Struct.new(:version, :loglevel, :show_help, :quiet, :culldays)
  class Configuration
    include Singleton

    @@config = ConfigurtionStruct.new

    @@config.version = nil
    @@config.loglevel = Logger::WARN
    @@config.show_help = false
    @@config.culldays = 365
    def self.config
      yield(@@config) if block_given?
      @@config
    end

    def self.to_hash
      Hash[@@config.each_pair.to_a]
    end

    def self.method_missing(method, *args, &block)
      if @@config.respond_to?(method)
        @@config.send(method, *args, &block)
      else
        raise NoMethodError
      end
    end

    def self.validate!
      valid = true
      #      valid = false if Configuration.required.nil?
      #      valid = false if Configuration.enum.nil? or Configuration.list.nil?
      raise ArgumentError unless valid
    end

  end

  class CliParser
    #    @command_name = 'ewinparser'
    def self.parse(args)

      opts = OptionParser.new do |parser|
        parser.separator ""
        parser.separator "Specific usage:"
        parser.separator ""

        parser.on("-i", "--infile JSONFILENAME", "File containing current EWIN database in json format") do |infile|
          Configuration.inputfile = infile
        end

        parser.on("-o", "--outfile JSONFILENAME", "File where the updated EWIN database will be saved in json format") do |outfile|
          Configuration.outputfile = outfile
        end

        parser.on("-d", "--inputdir DIRECTORY", "Location of EWINs to process") do |directory|
          Configuration.directory = directory
        end

        parser.on("-j", "--joinfile JSONFILENAME", "Json file to merge with the current EWIN database") do |directory|
          Configuration.directory = directory
        end

        parser.on("-m", "--manualfile FILENAME", "The file with manual entries from files that aren't parsed",
        "  File format is [ENTRY], [FILENAME]",
        "  ENTRY - ip, email address, domain name",
        "  FILENAME - File name where the ENTRY was found") do |file|
          Configuration.manualfile = file
        end

        parser.on("-c", "--culldays DAYS", "OptionalAge in days to remove entries from the data base.",
        "  The default is a year (365)") do |days|
          Configuration.culldays = days
        end

        parser.on("-t", "--ticketfile FILENAME", "Formatted output is saved to this file. Three other files are created as well",
        "  One for firewall, one for the webfilter, and one for the email filter.",
        "  These files use the tiket files as a base name for their file names.",
        "  The default is to be displayed on the screen") do |file|
          Configuration.ticketfile = file
        end

        parser.on("--loglevel=LEVEL", [:error, :warn, :info, :debug], "Set logging level (error, warn, info, debug)") do |level|
          Configuration.loglevel = log_level_parse(level)
        end

        parser.on_tail("-h", "--help", "Show this message") do
          puts parser
          puts "\n"
          Configuration.show_help = true
        end
      end

      # Parse the options
      opt_parser.parse!(args)

    end

    def self.help
      parse(['--help'])
    end

    # Parse a log level argument into the appropriate Logger constant
    def self.log_level_parse(level)
      if(level == :info)
        return Logger::INFO
      elsif(level == :debug)
        return Logger::DEBUG
      elsif(level == :warn)
        return Logger::WARN
      elsif(level == :error)
        return Logger::ERROR
      end
    end

  end
end

