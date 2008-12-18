require 'active_record'

class Score < ActiveRecord::Base
  belongs_to :machine
  belongs_to :player

  def self.top_five_scores_by_machine_id(machine_id)
    return Score.find_all_by_machine_id(machine_id, 
    :select => 'id, machine_id, player_id, max(score) as score',
    :order => "score desc", :group => 'machine_id, player_id', :limit => 5) 
  end
  
  def self.add_high_score(player, machine, score)
    return if (player.match(/select/i) || machine.match(/select/i))
    player = Player.find_or_create_by_name(player)
    machine = Machine.find_or_create_by_name(machine)
    high_score = player.high_score(machine)
    if(high_score.nil?) #create new score if user has never played
      score = Score.new(:score => score)
      score.save
      player.score << score
      machine.score << score
      player.save
      machine.save
    else #only keep highest score per game
      if(high_score.score < score)
        high_score.score = score
        high_score.save
      end
    end
  end

  def to_s
    "player: #{player.name} machine: #{machine.name} score: #{score.formatWithComma}"
  end
  
  def formatWithComma
    return score.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
end
  
  def <=>(o) 
    return -1 * (self.score <=> o.score )
  end

end
