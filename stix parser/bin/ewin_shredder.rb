$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

#!/usr/bin/env ruby
require 'ewinparser'
require 'ewinparser/cli_parser'
require 'ewinparser/db_parser'
require 'ewinparser/scrubber'
require 'ewinparser/spreadsheet_parser'


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
#    @database = Ewinparser::Db_parser.parse(opts['jsonfile'])
#    @output = Ewinparser::Stix_parser.parse('C:\Users\tpegg\Desktop\privilege\IB-14-20059.stix.xml')
    @output = Ewinparser::Spreadsheet_parser.parse('C:\Users\tpegg\Desktop\privilege\ANUNAK_02-20-2015.xlsx')
#    @output.each do |k,v|
#      @clean_output = Ewinparser.clean_input(k)
#    end
#    puts @clean_output
  rescue Errno::ENOENT => e
    $stderr.puts e.message
  end

end

def help
  Ewinparser::CliParser.help
  exit
end

main()

