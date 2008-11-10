require 'rubygems'
require 'test/unit'
require 'high_score_app_helper'

#TODO Make these tests so they don't break when I change the seconds constant :(
class TestHighScoreAppHelper < Test::Unit::TestCase
  def test_display_overall_method_flips_every_other_period
    #This method ensures we display the overall stats after every machine's stats
    helper = HighScoreAppHelper.new
    assert_equal(true, helper.display_overall?(0))
    assert_equal(false, helper.display_overall?(1))
    assert_equal(true, helper.display_overall?(2))
    assert_equal(false, helper.display_overall?(11))
  end

  def test_increment_loops_over_machine_index
    helper = HighScoreAppHelper.new
    machines = [1,2]
    assert_equal(0, helper.increment_machine_index(machines))
    assert_equal(1, helper.increment_machine_index(machines))
    assert_equal(0, helper.increment_machine_index(machines))
    assert_equal(1, helper.increment_machine_index(machines))
  end
end
