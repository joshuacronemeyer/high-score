require 'rubygems'
require 'test/unit'
require 'database'
require 'score'
require 'player'
require 'machine'

class TestMachine < Test::Unit::TestCase
  def test_is_grudge_match_machine
    Database.test_connect
    Score.add_high_score("js","js",23)
    assert(!Machine.find_by_name("js").is_grudge_match_machine?)
    GrudgeMatch.add_score("js","ps","Galaga")
    assert(Machine.find_by_name("Galaga").is_grudge_match_machine?)
    Database.disconnect
  end
  
  def test_scores_only_gets_highest_per_machine
    Database.test_connect
    Score.add_high_score("AA", "M1", 100)
    assert_equal(1, Machine.find_by_name("M1").score.size())
    Score.add_high_score("AA", "M2", 200)
    Score.add_high_score("AA", "M1", 300)
    assert_equal(2, Machine.find_by_name("M1").score.size())
  end
end
