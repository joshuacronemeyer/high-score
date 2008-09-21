require 'rubygems'
require 'test/unit'
require 'high_score_app_helper'

class TestHighScoreAppHelper < Test::Unit::TestCase
  def test_display_overall_flips_halfway_through_every_period_so_we_can_show_overall_after_each_machine
    #This method ensures we display the overall stats after every machine's stats
    helper = HighScoreAppHelper.new
    assert_equal(false, helper.display_overall?(0))
    assert_equal(false, helper.display_overall?(1))
    assert_equal(false, helper.display_overall?(2))
    assert_equal(true, helper.display_overall?(3))
    assert_equal(true, helper.display_overall?(4))
    assert_equal(true, helper.display_overall?(5))
    assert_equal(false, helper.display_overall?(6))
  end

  def test_increment_only_increments_after_the_specified_number_of_frames_is_displayed
    #this is how we hack the shoes animation to 'update' the screen every so often
    helper = HighScoreAppHelper.new
    machines = [1,2]
    assert_equal(0, helper.increment_machine_index_based_on_frame(0, machines))
    assert_equal(0, helper.increment_machine_index_based_on_frame(1, machines))
    assert_equal(0, helper.increment_machine_index_based_on_frame(2, machines))
    assert_equal(0, helper.increment_machine_index_based_on_frame(3, machines))
    assert_equal(0, helper.increment_machine_index_based_on_frame(4, machines))
    assert_equal(0, helper.increment_machine_index_based_on_frame(5, machines))
    assert_equal(1, helper.increment_machine_index_based_on_frame(6, machines))
    assert_equal(0, helper.increment_machine_index_based_on_frame(12, machines))
  end
end
