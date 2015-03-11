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
        opts.separator "Usage: #{@@command_name} [options] [goals]"
        opts.separator ""
#        opts.separator "goals defaults to 'cond_stop deploy start'"
#        opts.separator "NOTE: Goals will be run in the provided order.  It is up to you to not do something dumb."
#        opts.separator ""

        opts.separator "Specific options:"

        opts.on("-j", "--jsonfile JSONFILENAME", "Current database of findings from previous EWINs") do |jsonfile|
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
#          GoalRunner.help
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
        options.db_dir = 'db'
        options.show_help = false
        options.quiet = false
        options.config_key = nil

        options
    end


    def self.help
        parse(['--help'])
    end

  end
end

