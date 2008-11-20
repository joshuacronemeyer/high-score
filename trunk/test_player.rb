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

  def test_did_not_already_play
    p = Player.new(:name => 'fanullone')
    assert(!p.already_played_this_game?("asdf"))
  end

  def test_already_played_this
    GrudgeMatch.add_score("hj","hjk","asdf")
    assert(Player.find_by_name("hj").already_played_this_game?("asdf"))
  end

  def test_calculating_lots_of_scores
    Score.add_high_score("asdf", "adf", 3)
    Player.find(:all).each do |player|
      output = "#{player.name} - #{player.overall_score}"
      assert_equal("asdf - 20.0", output)
    end
  end

  def test_only_one_score_per_machine
    Score.add_high_score("JC", "WWJD", 77777)
    Score.add_high_score("JC", "WWJD", 77778)
    assert_equal(20, Player.find_by_name("JC").overall_score)
  end

  def test_scoring_for_grudge_matches
    GrudgeMatch.add_score("JC", "WWJD", "TMNT")
    assert_equal(Player::GRUDGE_MATCH_WIN, Player.find_by_name("JC").overall_score)
    assert_equal(Player::GRUDGE_MATCH_LOSS, Player.find_by_name("WWJD").overall_score)
  end
  
  def test_sorted_overall
    Score.add_high_score("JC", "WWJD", 77777)
    Score.add_high_score("DJ", "WWJD", 77779)
    Score.add_high_score("JD", "WWJD", 77778)
    players = Player.sorted_overall_scores()
    assert_equal("DJ", players.first.name)
    assert_equal("JC", players.last.name)
    Score.add_high_score("JC", "WW2", 234)
    players = Player.sorted_overall_scores()
    assert_equal("JC", players.first.name)
  end

  def test_unplayed_games
    Score.add_high_score("JC", "WWJD", 777)
    Machine.find_or_create_by_name("cool")
    assert_equal("cool", Player.find_or_create_by_name("JC").unplayed_games.first.name)
  end

  def test_ppg_test_andy_should_have_written_the_first_time
    Score.add_high_score("JC", "WWJD", 1000)
    Score.add_high_score("JC", "WWJD", 1)
    assert_equal(20.0, Player.find_or_create_by_name("JC").ppg)
  end
end