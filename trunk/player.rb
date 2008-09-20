require 'active_record'

class Player < ActiveRecord::Base
  TOP_SCORE = 20
  GRUDGE_MATCH_WIN = 20
  GRUDGE_MATCH_LOSS = 17
  has_many :score
  has_many :wins, :foreign_key => 'winner_id', :class_name => 'GrudgeMatch'
  has_many :losses, :foreign_key => 'loser_id', :class_name => 'GrudgeMatch'

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
    return overall_score + grudge_match_scores
  end

  private
  def sorted_top_scoreable_scores(machine_id)
    Score.find_all_by_machine_id(machine_id, :order => "score").reverse[0..TOP_SCORE-1]
  end

  def grudge_match_scores()
    return (wins.size * GRUDGE_MATCH_WIN) + (losses.size * GRUDGE_MATCH_LOSS)
  end
end
