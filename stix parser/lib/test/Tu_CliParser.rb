require_relative '../ewinparser/cli_parser'
require "test/unit"

class Tu_CliParser  < Test::Unit::TestCase
  def test_cli_parser
    config = Ewinparser::Configuration
    cli_parser = Ewinparser::CliParser

    cli_parser.parse(["--loglevel=info"])

    assert_equal(Logger::INFO, config.loglevel)

#    cli_parser.parse(["--version"])
  end

end