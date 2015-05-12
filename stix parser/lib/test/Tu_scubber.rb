require_relative '../ewinparser/scrubber'
require "test/unit"

class Tu_scubber < Test::Unit::TestCase
  def test_scrubber
    test_hash = Hash.new

    test_hash["www.google.com"] = [[  "domainnameobj",  "unknown",  "ticket: 91535",  "2015-03-24 09:00:00 -0500"],7]
    test_hash["http://www.abc.com"] = [[  "domainnameobj",  "unknown",  "ticket: 12345",  "2015-04-24 09:00:00 -0500"],7]
    test_hash["192.168.10.20"] = [[  "domainnameobj",  "unknown",  "ticket: 2345",  "2015-05-24 09:00:00 -0500"],7]
    test_hash["10.10.10.20"] = [[  "domainnameobj",  "unknown",  "ticket: 2345",  "2015-06-24 09:00:00 -0500"],7]

    clean_hash = Ewinparser.clean_hash(test_hash)

    assert_equal(7, clean_hash["www.google.com"][1])
    assert_equal(["www.google.com", "www.abc.com"], clean_hash.keys())

    test_hash2 = Hash.new

    test_hash2["www.google.com"] = [  "domainnameobj",  "unknown",  "ticket: 91535",  "2015-03-24 09:00:00 -0500"]
    test_hash2["http://www.abc.com"] = [  "domainnameobj",  "unknown",  "ticket: 12345",  "2015-04-24 09:00:00 -0500"]
    test_hash2["192.168.10.20"] = [  "domainnameobj",  "unknown",  "ticket: 2345",  "2015-05-24 09:00:00 -0500"]
    test_hash2["10.10.10.20"] = [  "domainnameobj",  "unknown",  "ticket: 2345",  "2015-06-24 09:00:00 -0500"]

    clean_hash2 = Ewinparser.clean_hash(test_hash2)
    assert_equal(["www.google.com", "www.abc.com"], clean_hash2.keys())

  end

end