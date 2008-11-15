require 'rubygems'
require 'test/unit'
require 'database'
require 'mocha'
require 'score'
require 'player'
require 'machine'

class TestScore < Test::Unit::TestCase
  def test_top_five_scores_by_machine_id_returns_five
    Database.test_connect
    Score.add_high_score("AA", "M1", 100);
    Score.add_high_score("AA", "M1", 200);
    Score.add_high_score("AB", "M1", 101);
    Score.add_high_score("AC", "M1", 102);
    Score.add_high_score("AD", "M1", 300);
    Score.add_high_score("AE", "M1", 150);
    
    assert_equal(5, Score.top_five_scores_by_machine_id(1).size)
  end

  def test_add_high_score_creates_record
    Database.test_connect
    Score.add_high_score("JC", "WWJD", "100000")
    player = Player.find_by_name("JC")
    score = Score.find_by_player_id(player.id)
    machine = Machine.find_by_name("WWJD")
    assert_not_nil(player)
    assert_not_nil(machine)
    assert_not_nil(score)
    Database.disconnect
  end

  def test_add_high_score_doesnt_create_duplicate_player
    Database.test_connect
    Player.new(:name => "JC")
    Score.add_high_score("JC", "WWJD", "77777")
    assert_equal(1,Player.find_all_by_name("JC").size)
    Database.disconnect
  end

  def test_add_high_score_doesnt_create_duplicate_machine
    Database.test_connect
    Machine.new(:name => "JC")
    Score.add_high_score("JC", "WWJD", "77777")
    assert_equal(1,Machine.find_all_by_name("WWJD").size)
    Database.disconnect
  end

end
