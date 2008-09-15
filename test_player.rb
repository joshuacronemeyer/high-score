require 'rubygems'
require 'test/unit'
require 'database'
require 'mocha'
require 'score'
require 'player'
require 'machine'

class TestPlayer < Test::Unit::TestCase
  def test_score_calculated_correctly
    Database.test_connect
    Score.add_high_score("JC", "WWJD", 77777)
    assert_equal(20, Player.find_by_name("JC").overall_score)
    Score.add_high_score("JC", "Galaga", 20000)
    assert_equal(40, Player.find_by_name("JC").overall_score)
    Database.disconnect
  end

  def test_only_one_score_per_machine
    Database.test_connect
    Score.add_high_score("JC", "WWJD", 77777)
    Score.add_high_score("JC", "WWJD", 77778)
    assert_equal(20, Player.find_by_name("JC").overall_score)
    Database.disconnect
  end
end
