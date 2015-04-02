$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

#!/usr/bin/env ruby
require 'ewinparser'
require 'ewinparser/cli_parser'

#require 'ewinparser/db_parser'
require 'ewinparser/ewinstore.rb'
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

  begin

    @database =  Ewinparser::Ewinstore
    #    @database.import(opts['inputfile'])
    #    @database.cull(100)
    #    @database.export(opts['outputfile'])

    #    Ewinparser::ewinstore.import(opts['inputfile'])

    #    @output = Ewinparser::Stix_parser.parse('C:\Users\tpegg\Desktop\privilege\IB-14-20059.stix.xml')
    #    @output = Ewinparser::Spreadsheet_parser.parse('C:\Users\tpegg\Desktop\privilege\ANUNAK_02-20-2015.xlsx')
    #    @output.each do |k,v|
    #      @clean_output = Ewinparser.clean_input(k)
    #    end
    #    puts @clean_output
    @files = Dir.entries(opts['directory']).select {|f| !File.directory? f}

    Dir.chdir opts['directory']

    @stix_files = @files.grep(/(.*)[Ss][Tt][Ii][Xx]\.[Xx][Mx][Ll]$/)
    @xlxs_files = @files.grep(/(.*)[Xx][Ll][Ss][Xx]$/)
    @xlx_files = @files.grep(/(.*)[Xx][Ll][Ss]$/)
    @csv_files = @files.grep(/(.*)[Cc][Ss][Vv]$/)

    @parsed_files = Array.new

    # TODO clean input and validate emails
    @files.each do |file|
      
      
      if file =~ /(.*)[Ss][Tt][Ii][Xx]\.[Xx][Mm][Ll]$/
        @output_hash = Hash.new()
        @output_hash = Ewinparser::Stix_parser.parse(file)
        if (!@output_hash.nil?)
          @database.add_hash( @output_hash )
          @parsed_files.push([file, @output_hash.length])
        end
      end

      
      if file =~ /(.*)[Xx][Ll][Ss][Xx]$/
        
        @output_hash = Hash.new()
        @output_hash = Ewinparser::Spreadsheet_parser.parse(file)
          
        if (!@output_hash.nil?)
          @database.add_hash( @output_hash )
          @parsed_files.push([file, @output_hash.length])
        end
      end

      # TODO Handle CSV files.
#      if file =~ /(.*)[Cc][Ss][Vv]$/
#        @database.add_hash( Ewinparser::Spreadsheet_parser.parse(file) )
#        @parsed_files.push(file)
#      end

    end

    puts "%s results:" % [Ewinparser::CliParser.command_name]
    puts "\t Files provided %d " % [ @files.length ]
    puts "\t Files parsed: %d" % [@parsed_files.length]
    puts "\t Entries found: %d" % [@database::ewin_store_length]
    puts "Files Parsed: "
    @parsed_files.each do | file |
      puts "\t %-35s Entries: %4s" % [file[0],file[1]]
    end

  rescue Errno::ENOENT => e
    $stderr.puts e.message
  end

end

def help
  Ewinparser::CliParser.help
  exit
end

main()

