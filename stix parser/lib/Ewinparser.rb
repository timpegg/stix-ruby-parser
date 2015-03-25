require 'logger'
require 'json'

require_relative 'ewinparser/version'
require_relative 'ewinparser/cli_parser'

module Ewinparser
  def self.logger
    unless(@logger)
      default_logger()
    end
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    @logger.formatter = lambda do |severity, datetime, progname, msg|
      #  "#{datetime}:#{progname}: #{severity}: #{msg}\n"
      "#{@@command_name}StixParser: %-10s: %10s\n" % [ severity, datetime, progname, msg]
    end

    @logger
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.default_logger
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  #  # Syntactic sugar entry point
  #  def self.project_from_file(file)
  #      ConfigParser.project_from_file(file)
  #  end

  def self.load_database_from_file(file)
    @file = open(file)
    @json = @file.read

    @parsed = JSON.parse(@json)

    logger.info  "Load_database_from_file:  Reading #{file}"
    @parsed.each do | key,value |
      logger.debug  "JSON parsed: " + "%-25s  %25s" % [ key, value]
    end
    logger.debug  "Load_database_from_file"

  end

end