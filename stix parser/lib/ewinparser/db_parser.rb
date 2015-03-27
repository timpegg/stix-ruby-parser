module Ewinparser

  class Db_parser
    def self.parse(file)

      @file = open(file)
      @json = @file.read

      @parsed = JSON.parse(@json)

      Ewinparser.logger.debug "Load_database_from_file Start"
      Ewinparser.logger.info  "Load_database_from_file:  Reading #{file}"
      @parsed.each do | key,value |
        Ewinparser.logger.debug  "Load_database_from_file -> Parsed: " + "%-25s  %25s" % [ key, value]
      end
      Ewinparser.logger.debug "Load_database_from_file End"

      @parsed

    end
  end

end