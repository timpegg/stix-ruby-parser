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
        #TODO Add more command usage information

        opts.separator "Specific options:"

        opts.on("-i", "--infile JSONFILENAME", "Input file in json format that contains the current EWIN database") do |infile|
          options.inputfile = infile
        end

        opts.on("-o", "--outfile JSONFILENAME", "Output file for the updated EWIN database") do |outfile|
          options.outputfile = outfile
        end

        opts.on("-d", "--inputdir DIRECTORY", "Location of EWINs") do |directory|
          options.directory = directory
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
      #      raise OptionParser::MissingArgument if options[:outfile].nil?

      options

    end

    def self.default_options
      options = OpenStruct.new
      options.version = nil
      options.loglevel = Logger::INFO
      options.show_help = false
      options.quiet = false

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

