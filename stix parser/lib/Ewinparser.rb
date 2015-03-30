require 'logger'
require 'json'

require_relative 'ewinparser/version'
require_relative 'ewinparser/cli_parser'
require_relative 'ewinparser/stix_parser'
require_relative 'ewinparser/scrubber'


module Ewinparser
  def self.logger
    unless(@logger)
      default_logger()
    end
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    @logger.formatter = lambda do |severity, datetime, progname, msg|
      "%-6s: #{Ewinparser::CliParser.command_name}: %10s\n" % [ severity, msg]
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


end