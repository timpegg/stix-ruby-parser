#!/usr/bin/env ruby
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")

#!/usr/bin/env ruby
require 'ewinparser'
require 'ewinparser/cli_parser'
require 'ewinparser/ewinstore'
require 'ewinparser/printer'
require 'ewinparser/spreadsheet_parser'

require 'ruby-progressbar'

def main
  opts = nil

  begin
    opts = Ewinparser::CliParser.parse(ARGV)
  rescue OptionParser::InvalidOption => e
    puts e.message, ""
    help
  rescue OptionParser::MissingArgument => e
    puts e.message, "-o FILE and either -i FILENAME or -m FILENAME is required\n\n"
    help
  end

  Ewinparser.logger.level = opts['loglevel']

  if opts.show_help
    exit
  end

  begin

    @database =  Ewinparser::Ewinstore
    @database.import(opts['inputfile']) if !opts['inputfile'].nil?
    @parsed_files = Array.new
    @files = Array.new

    if !opts['directory'].nil?
      @files = Dir.entries(opts['directory']).select {|f| !File.directory? f}

      Dir.chdir opts['directory']

      if !@files.nil?
        @file_processing_bar = ProgressBar.create(:title=> "Processing Files", :total=>@files.length, :starting_at => 0 )

        @files.each do |file|

          if file =~ /(.*)[Ss][Tt][Ii][Xx]\.[Xx][Mm][Ll]$/
            @output_hash = Hash.new()
            @output_hash = Ewinparser::Stix_parser.parse(file)
            @file_processing_bar.increment

            if (!@output_hash.nil?)
              @clean_hash = Ewinparser::clean_hash(@output_hash)
              @database.add_hash( @clean_hash )
              @parsed_files.push([file, @clean_hash.length])
            end
          end

          if file =~ /(.*)[Xx][Ll][Ss][Xx]$/

            @output_hash = Hash.new()
            @output_hash = Ewinparser::Spreadsheet_parser.parse(file)
            @file_processing_bar.increment

            if (!@output_hash.nil?)
              @clean_hash = Ewinparser::clean_hash(@output_hash)
              @database.add_hash( @clean_hash )
              @parsed_files.push([file, @clean_hash.length])
            end
          end

          # TODO Handle CSV files.
          # There's not been any CSV files in a while. When there is we can update the script to include them.
        end
      end

    end

    if !opts['manualfile'].nil?
      @manual_hash = Hash.new
      File.open(opts['manualfile']).each do |line|
        @entry, @entryfile = line.match(/(^.*), (.*)/).captures
        if @entry =~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/
          @manual_type = 'ipobj'
        end

        if (@entry =~ /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}/ and !@entry.include?('@'))
          @manual_type = 'domainnameobj'
        end

        if @entry.include?("@")
          @manual_type = 'emailmessageobj'
        end

        if @entry
          @manual_hash[@entry] = [@manual_type, 'manual', @entryfile, Time.now.to_s]
        end
      end
      @database.add_hash( @manual_hash )
      @files.push("Manual File Entry")
      @parsed_files.push(["Manual File Entry", @manual_hash.length])
    end

    @file_processing_bar.finish
    puts ''
    puts ''
    puts "%s results:" % [Ewinparser::CliParser.command_name]
    puts "\t Files provided:        %4s" % [@files.length ]
    puts "\t Files parsed:          %4s" % [@parsed_files.length]
    @all_entries = 0
    @parsed_files.each do | file |
      @all_entries += file[1]
    end
    puts "\t All Enties found:      %4s" % [@all_entries]
    puts "\t Unique Entries found:  %4s" % [@database::ewin_store_length]
    puts
    puts "Files Parsed: "
    @parsed_files.each do | file |
      puts "\t %-35s Entries: %4s" % [file[0],file[1]]
    end

    puts
    puts

    @database.cull(opts['culldays'])
    @database.export(opts['outputfile'])

    Ewinparser::Printer.print_ticket(@files, opts['ticketfile'])

  rescue Errno::ENOENT => e
    $stderr.puts e.message
  end

end

def help
  Ewinparser::CliParser.help
  exit
end

main()

