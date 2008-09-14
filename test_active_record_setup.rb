require 'rubygems'
require 'test/unit'
#require 'mocha'
require 'database'
require 'player'
require 'score'
require 'machine'

class TestActiveRecordSetup < Test::Unit::TestCase

  def setup
    Database.test_connect
#    SharedFile.stubs(:fetch_content).returns(mock())
  end

  def teardown
    Database.disconnect
  end

  def test_setup_works
    score = Score.new()
    score.score = 25000
    score.save

    player = Player.new(:name => "JRC")#, :score => score)
    player.score << score
    player.save
    
    machine = Machine.new(:name => "Galaga")#, :score => score)
    machine.score << score
    machine.save
    
    assert_not_nil(Player.find_by_name("JRC"))
  end

end
