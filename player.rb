require 'active_record'
require 'machine'
require 'grudge_match'
require 'score'

class Player < ActiveRecord::Base
  TOP_SCORE = 20
  GRUDGE_MATCH_WIN = 20
  GRUDGE_MATCH_LOSS = 17
  has_many :score
  has_many :wins, :foreign_key => 'winner_id', :class_name => 'GrudgeMatch'
  has_many :losses, :foreign_key => 'loser_id', :class_name => 'GrudgeMatch'

  def overall_score
    overall_score = 0
    machines = self.score.collect{|score| score.machine}.uniq
    machines.each do |machine|
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

  def already_played_this_game?(machine)
    matches = self.wins + self.losses
    matches.each do |match|
      return true if match.machine.name == machine
    end
    return false
  end

  def self.sorted_overall_scores()
    players_by_scores = Player.find(:all)
    players_by_scores = players_by_scores.sort
    return players_by_scores.reverse
  end
  
  def ppg
    number_of_games = (score.size + wins.size + losses.size)
    if number_of_games > 0
      return overall_score / number_of_games 
    else
      return 0
    end
  end
  
  def <=> (other)
    return self.overall_score <=> other.overall_score
  end

  private
  def sorted_top_scoreable_scores(machine_id)
    Score.find_all_by_machine_id(machine_id, :order => "score", :limit => TOP_SCORE-1).reverse
  end

  def grudge_match_scores()
    return (wins.size * GRUDGE_MATCH_WIN) + (losses.size * GRUDGE_MATCH_LOSS)
  end
end
