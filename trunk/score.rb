require 'active_record'

class Score < ActiveRecord::Base
  belongs_to :machine
  belongs_to :player

  def to_s
    "player: #{player.name} machine: #{machine.name} score: #{score}"
  end
end
