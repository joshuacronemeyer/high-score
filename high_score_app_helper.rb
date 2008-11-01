#mainly have this class so we can test these methods away from the shoes stuff.
require 'machine'

class HighScoreAppHelper
  SECONDS_PER_SLIDE = 12 #must be multiple of 2

  attr_accessor :index
  def initialize
    @index = -1
    @overall_bit = true
  end

  def display_overall?(frame)
    @overall_bit = !@overall_bit if (frame % (SECONDS_PER_SLIDE/2) == 0)
    return @overall_bit
  end

  def increment_machine_index_based_on_frame(frame, machines)
    return 0 if machines.size == 0
    @index += 1 if ((frame % SECONDS_PER_SLIDE) == 0)
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
end
