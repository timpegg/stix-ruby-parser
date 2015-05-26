require_relative "../ewinparser/printer"
require_relative "../ewinparser/cli_parser"
require "test/unit"
require "flexmock/test_unit"

class TU_printer < Test::Unit::TestCase
  def test_outputdate 
#    puts "#{Ewinparser::Printer.add_date}"
  end
  
  def test_arrayhash
    unsorted = ['the@com', 'bcd@321','abc@123' ]
    sorted = [ 'abc@123', 'bcd@321', 'the@com' ]
    assert_equal sorted, Ewinparser::Printer.sort(unsorted)
    unsorted = ['10.20.30.40', '10.19.29.39','10.18.28.38' ]
    sorted = [ '10.18.28.38', '10.19.29.39', '10.20.30.40' ]
    assert_equal sorted, Ewinparser::Printer.sort(unsorted)
    unsorted = ['www.yahoo.com', 'www.india.com', 'www.google.com', 'www.hyvee.com' ]
    sorted = [ 'www.google.com', 'www.hyvee.com', 'www.india.com', 'www.yahoo.com' ]
    assert_equal sorted, Ewinparser::Printer.sort(unsorted)
  end
#  
#  def test_file_io
#    assert_equal IO.new(1), Ewinparser::Printer.file_io()
#    testfd = 
#  end
  
  def test_print_webfilter_ticket
    config = Ewinparser::Configuration
   
    
  end
end

