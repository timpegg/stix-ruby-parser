$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

#!/usr/bin/env ruby
require 'ewinparser'
require 'ewinparser/cli_parser'
#require 'ewinparser/goal_runner'

def main
  opts = nil

  begin
    opts = Ewinparser::CliParser.parse(ARGV)
  rescue OptionParser::InvalidOption => e
    puts e.message, ""
    help
  end

  Ewinparser.logger.level = opts['loglevel']

  # If the user requested the help message, don't continue
  if opts.show_help
    exit
  end

  # TODO Not sure what this is doing ... check to see if I need this..
#  runner = Ewinparser::GoalRunner.new(nil, opts)
#  runner.run_goals

  help unless opts.jsonfile

  begin
    database = Ewinparser.load_database_from_file(opts['jsonfile'])

  rescue Errno::ENOENT => e
    $stderr.puts e.message
  end

end

def help
  Ewinparser::CliParser.help
  exit
end

main()

