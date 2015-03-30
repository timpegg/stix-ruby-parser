require 'roo'
require 'time'
require_relative '../ewinparser'

module Ewinparser
  class Spreadsheet_parser
    def self.parse(file)
      @file = file

      @time = Time.now.to_s
      @results_hash = Hash.new

      #      @xls = Roo::Spreadsheet.open(@file)
      #TODO check to see if the file is csv or xls or xlsx
      # for now we'll just parse the xlsx files.
      @s = Roo::Excelx.new(@file)
      @file_name_comp = File.basename @file
      Ewinparser.logger.info "%-18s %s" % [ "spreadsheet_parser [full file name]:" , @file ]
      Ewinparser.logger.info "%-18s %s" % [ "spreadsheet_parser [file name]:" , @file_name_comp ]

      @s.default_sheet = @s.sheets.first

      @current_row = @s.first_row

      # The data in "Indicator reports starts in row 4.  We'll need to check the contents of Row 1 on to determine how to parse.
      if @s.row(1).include? "Indicator Report:"
        @current_row = 4
      end

      while @current_row <= @s.last_row
        Ewinparser.logger.debug "%-18s %s" % [ "Spreadsheet_parser [row]:" , @s.row(@current_row).to_s ]

        if !@s.cell(@current_row, 1).nil?
          case @s.cell(@current_row, 1)
          when "Identifier:"
            @identifier = @s.cell(@current_row, 2)
          when "IPs:"
            @ips = @s.cell(@current_row, 2)
          when "Type:"
            @type = @s.cell(@current_row, 2)
          when "Domain:"
            @domain = @s.cell(@current_row, 2)
          else
            Ewinparser.logger.debug "%-18s %s" % [ "Spreadsheet_parser [skipped row]:" , @s.row(@current_row).to_s ]        
          end
          if (@s.cell(@current_row, 1).to_s.include? "Identifier:")
            @type = @s.cell(@current_row, 2)
          end
        else
          if (@identifier.to_s.include? "Attacker" and (!@ips.nil? or !@domain.nil?))
            case @type
            when nil
              @type = "not defined"
            when "C&C"
              @type = "command and control"
            else
            end
            
            if @ips.nil?
              @key = @domain.downcase
            else
              @key = @ips
            end
            Ewinparser.logger.info "%-18s %s %s %s %s" % [ "Spreadsheet_parser [result]:" , @key, @type, @file_name_comp, @time ]

            @results_hash[@key] = ["uri", @type.downcase, @file_name_comp.downcase, @time]
              
          end

          #now clear the contents of the record
          @identifier = nil
          @ips = nil
          @type = nil
          @domain = nil

        end

        @current_row += 1
      end
      
    end

  end
end

