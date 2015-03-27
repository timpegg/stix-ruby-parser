$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

#!/usr/bin/env ruby
require 'ewinparser'
require 'ewinparser/cli_parser'
require 'ewinparser/db_parser'

def main
  opts = nil

  begin
    opts = Ewinparser::CliParser.parse(ARGV)
  rescue OptionParser::InvalidOption => e
    puts e.message, ""
    help
  end

  Ewinparser.logger.level = opts['loglevel']

  if opts.show_help
    exit
  end

  help unless opts.jsonfile

  begin
    @database = Ewinparser::Db_parser.parse(opts['jsonfile'])
    @output = Ewinparser::StixParser.parse('C:\Users\tpegg\Desktop\privilege\IB-14-20054.stix.xml')
    @clean_output
    
  rescue Errno::ENOENT => e
    $stderr.puts e.message
  end

end

def help
  Ewinparser::CliParser.help
  exit
end

main()

