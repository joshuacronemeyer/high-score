#mainly have this class so we can test these methods away from the shoes stuff.
require 'machine'

class HighScoreAppHelper

  attr_accessor :index
  def initialize
    @index = -1
  end

  def display_overall?(frame)
    frame % 2 == 0
  end

  def increment_machine_index(machines)
    @index = 0 if machines.size == 0
    @index += 1
    @index %= machines.size
  end
  
  def get_machine_names
    machineNames = []
    machines = Machine.all(:select => 'name')
    machines.each do |machine|
      machineNames << machine.name
    end
    return machineNames
  end
  
  def get_player_names
    playerNames = []
    players = Player.all(:select => 'name')
    players.each do |player|
      playerNames << player.name
    end
    return playerNames
  end
end
