require 'optparse'
require 'ostruct'
require 'logger'

# Command line option parser
module Ewinparser
  class CliParser

    @command_name = 'ewinparser'
    def self.parse(args)
      options = default_options()

      opt_parser = OptionParser.new do |opts|
        opts.banner = "#{@command_name} - #{Ewinparser::VERSION}"
        opts.separator ""
        opts.separator "Usage: #{@command_name} [options]"
        opts.separator ""
        opts.separator "This script will process EWIN files looking for valid email addresses, IP addresses, URIs and domain/host"
        opts.separator "names.  These results are compared with the current database of entries.  If the entry matches an"
        opts.separator "existing entry then it’s updated.  After updates are met the database removes any entries that are older"
        opts.separator "than a year.  Once the database run is complete, the results are displayed.  These results are formatted" 
        opts.separator "for the HEAT ticket."
        opts.separator ""

        opts.separator "Specific options:"

        opts.on("-i", "--infile JSONFILENAME", "File containing current EWIN database in json format") do |infile|
          options.inputfile = infile
        end

        opts.on("-o", "--outfile JSONFILENAME", "File where the updated EWIN database will be saved in json format") do |outfile|
          options.outputfile = outfile
        end

        opts.on("-d", "--inputdir DIRECTORY", "Location of EWINs to process") do |directory|
          options.directory = directory
        end

        opts.on("-j", "--joinfile JSONFILENAME", "Json file to merge with the current EWIN database") do |directory|
          options.directory = directory
        end

        opts.on("-m", "--manualfile FILENAME", "The file with manual entries from files that aren't parsed",
                                               "  File format is [ENTRY], [FILENAME]",
                                               "  ENTRY - ip, email address, domain name",
                                               "  FILENAME - File name where the ENTRY was found") do |file|
          options.manualfile = file
        end

        opts.on("-c", "--culldays DAYS", "OptionalAge in days to remove entries from the data base.", 
                                         "  The default is a year (365)") do |days|
          options.culldays = days
        end

        opts.on("-t", "--ticketfile FILENAME", "Formatted output is saved to this file. Three other files are created as well",
                                               "  One for firewall, one for the webfilter, and one for the email filter.",
                                               "  These files use the tiket files as a base name for their file names.",
                                               "  The default is to be displayed on the screen") do |file|
          options.ticketfile = file
        end

        opts.on("--loglevel=LEVEL", [:error, :warn, :info, :debug], "Set logging level (error, warn, info, debug)") do |level|
          options.loglevel = log_level_parse(level)
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          puts "\n"
          options.show_help = true
        end
      end

      # Parse the options
      opt_parser.parse!(args)

      # Here for mandatory arguments
      raise OptionParser::MissingArgument if ((options[:outfile].nil? and (options[:manualfile].nil? and options[:directory].nil?)) and !options.show_help)
      
      options

    end

    def self.default_options
      options = OpenStruct.new
      options.version = nil
      options.loglevel = Logger::WARN
      options.show_help = false
      options.quiet = false
      options.culldays = 365
      
      options
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

    def self.command_name
      @command_name
    end

  end
end

