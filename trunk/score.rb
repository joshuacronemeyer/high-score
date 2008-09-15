require 'active_record'

class Score < ActiveRecord::Base
  belongs_to :machine
  belongs_to :player

  def self.top_five_scores_by_machine_id(machine_id)
    return Score.find_all_by_machine_id(machine_id, :order => "score").reverse[0..4] 
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
    "player: #{player.name} machine: #{machine.name} score: #{score}"
  end

end
