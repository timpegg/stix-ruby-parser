require 'optparse'
require 'ostruct'
require 'logger'

# Command line option parser
module Ewinparser
  class CliParser
    @@command_name = 'ewinparser'

    
    def self.parse(args)
      options = default_options()

      opt_parser = OptionParser.new do |opts|
        opts.banner = "ewinparser - v#{Ewinparser::VERSION}"
        opts.separator ""
        opts.separator "Usage: #{@@command_name} [options]"
        opts.separator ""

        opts.separator "Specific options:"

        # This is the file used as the database.  If the file is empty then the script generates a new database.
        # TODO Create an entry for the JSONFile that has the some file meta data information. Need to think if there is any useful information for this header.
        opts.on("-j", "--jsonfile JSONFILENAME", "Output from previous #{@@command_name} execution.",
                                                 " If this is empty or dosen't exist this is where the output will be kept",
                                                 " If the file has contents this will be updated with the current information") do |jsonfile|
          options.jsonfile = jsonfile
        end
        
        opts.on("-d", "--inputdir DIRECTORY", "Location of EWINs") do |jsonfile|
          options.jsonfile = jsonfile
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
      @@command_name 
    end
    
  end
end

