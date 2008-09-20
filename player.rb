require 'active_record'

class Player < ActiveRecord::Base
  TOP_SCORE = 20#points
  has_many :score
  has_many :grudge_match

  def overall_score
    overall_score = 0
    Machine.find(:all).each do |machine|
      high_scores = sorted_top_scoreable_scores(machine.id)
      high_scores.each_with_index do |hi_score, index|
        if (hi_score.player.id == self.id)
          overall_score += (TOP_SCORE - index)
          break
        end
      end
    end
    return overall_score
  end

  private
  def sorted_top_scoreable_scores(machine_id)
    Score.find_all_by_machine_id(machine_id, :order => "score").reverse[0..TOP_SCORE-1]
  end
end
