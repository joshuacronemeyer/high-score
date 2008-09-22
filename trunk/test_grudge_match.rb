require 'rubygems'
require 'test/unit'
require 'database'
require 'player'
require 'machine'
require 'grudge_match'

class TestGrudgeMatch < Test::Unit::TestCase
  def test_we_can_create_grudge_match
    GrudgeMatch.add_score("JC", "EvilJC", "Galaga")
    assert_equal(1,GrudgeMatch.find(:all).size)
  end

  def test_really_only_one_match_per_player_per_game
    GrudgeMatch.add_score("JC", "JD", "Galaga")
    assert_raise(RuntimeError){GrudgeMatch.add_score("JD","JC", "Galaga")}
  end

  def setup
    Database.test_connect
  end
  
  def teardown
    Database.disconnect
  end
end
