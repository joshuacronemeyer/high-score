require 'rubygems'
require 'test/unit'
require 'database'
require 'player'
require 'machine'
require 'grudge_match'

class TestGrudgeMatch < Test::Unit::TestCase
  def test_we_can_create_grudge_match
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    Database.test_connect
    GrudgeMatch.add_score("JC", "EvilJC", "Galaga")
    assert_equal(1,GrudgeMatch.find(:all).size)
    Database.disconnect
  end

end
