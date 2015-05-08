require_relative "../ewinparser/cli_parser"
require "test/unit"

class TestConfiguration < Test::Unit::TestCase

  @@config = Ewinparser::Configuration.clone
  
  def test_config_defaults

    assert_equal(nil, @@config.version)
    assert_equal(Logger::WARN, @@config.loglevel)
    assert_equal(false, @@config.show_help)
    assert_equal(365, @@config.culldays)
    assert_equal({:version=>nil, :loglevel=>2, :show_help=>false, :quiet=>nil, :culldays=>365}, @@config.to_hash)

    @@config.version = 42
    assert_equal(42, @@config.version)

    @@config.loglevel = Logger::INFO
    assert_equal(Logger::INFO, @@config.loglevel)

    @@config.show_help = true
    assert_equal(true, @@config.show_help)

    @@config.culldays = 31
    assert_equal(31, @@config.culldays)

    @@config.quiet = true
    assert_equal(true, @@config.quiet)

    assert_equal({:version=>42, :loglevel=>1, :show_help=>true, :quiet=>true, :culldays=>31}, @@config.to_hash)
      
    @@config = {:version=>nil, :loglevel=>2, :show_help=>false, :quiet=>nil, :culldays=>365}
    
  end
  
  def test_cli_parser 
    
  end
end