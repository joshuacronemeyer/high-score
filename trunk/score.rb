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
    player = Player.find_or_create_by_name(player)
    score = Score.new(:score => score)
    machine = Machine.find_or_create_by_name(machine)
    score.save
    player.score << score
    machine.score << score
    player.save
    machine.save
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
