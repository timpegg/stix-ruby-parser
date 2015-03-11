require 'logger'

require_relative 'ewinparser/version'

module Ewinparser
  def self.logger
      unless(@logger)
          default_logger()
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

  # Syntactic sugar entry point
  def self.project_from_file(file)
      ConfigParser.project_from_file(file)
  end


end