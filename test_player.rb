require 'rubygems'
require 'test/unit'
require 'database'
require 'mocha'
require 'score'
require 'player'
require 'machine'

class TestPlayer < Test::Unit::TestCase
  def setup
    Database.test_connect
  end
  def teardown
    Database.disconnect
  end

  def test_score_calculated_correctly
    Score.add_high_score("JC", "WWJD", 77777)
    assert_equal(20, Player.find_by_name("JC").overall_score)
    Score.add_high_score("JC", "Galaga", 20000)
    assert_equal(40, Player.find_by_name("JC").overall_score)
  end

  def test_calculating_lots_of_scores
    Score.add_high_score("asdf", "adf", 3)
    Player.find(:all).each do |player|
      output = "#{player.name} - #{player.overall_score}"
      assert_equal("asdf - 20", output)
    end
  end
  def test_only_one_score_per_machine
    Score.add_high_score("JC", "WWJD", 77777)
    Score.add_high_score("JC", "WWJD", 77778)
    assert_equal(20, Player.find_by_name("JC").overall_score)
  end

  def test_scoring_for_grudge_matches
    GrudgeMatch.add_score("JC", "WWJD", "TMNT")
    assert_equal(20, Player.find_by_name("JC").overall_score)
    assert_equal(17, Player.find_by_name("WWJD").overall_score)
  end
end
