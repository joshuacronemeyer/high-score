require 'active_record'
require 'player'
require 'machine'

class GrudgeMatch < ActiveRecord::Base
  belongs_to :machine
  belongs_to :winner, :foreign_key => 'winner_id', :class_name => 'Player'
  belongs_to :loser, :foreign_key => 'loser_id', :class_name => 'Player'

  def self.add_score(winner, loser, machine)
    winner = Player.find_or_create_by_name(winner.upcase)
    loser = Player.find_or_create_by_name(loser.upcase)
    raise "already played" if (winner.already_played_this_game?(machine.upcase))
    machine = Machine.find_or_create_by_name(machine.upcase)
    grudge_match = GrudgeMatch.new :winner => winner, :loser => loser, :machine => machine
    grudge_match.save
  end  

  def to_s
    "#{winner.name} conquered #{loser.name}"
  end

end
