module Ewinparser

  class Db_parser
    def self.parse(file)

      @file = open(file)
      @json = @file.read

      @parsed = JSON.parse(@json)

      Ewinparser.logger.debug "db_parser Start"
      Ewinparser.logger.info  "db_parser Reading #{file}"
      @parsed.each do | key,value |
        Ewinparser.logger.debug  "db_parser Parsed: " + "%-25s  %25s" % [ key, value]
      end
      Ewinparser.logger.debug "db_parser End"

      @parsed

    end
  end

end