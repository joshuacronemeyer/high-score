require 'rubygems'
require 'test/unit'

class TestMachine < Test::Unit::TestCase
  def test_is_grudge_match_machine
    Database.test_connect
    Score.add_high_score("js","js",23)
    assert(!Machine.find_by_name("JS").is_grudge_match_machine?)
    GrudgeMatch.add_score("js","ps","Galaga")
    assert(Machine.find_by_name("GALAGA").is_grudge_match_machine?)
    Database.disconnect
  end
end
