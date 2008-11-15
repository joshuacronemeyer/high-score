require 'active_record'

class Machine < ActiveRecord::Base
  has_many :score, :finder_sql =>
    'select id, machine_id, player_id, max(score) as score ' +
    'from scores ' +
    'where scores.machine_id = #{id} ' +
    'group by machine_id, player_id'
    
  has_many :grudge_match

  def is_grudge_match_machine?
    return self.grudge_match.size > 0
  end
  
  def <=>(o) 
    return (self.name <=> o.name )
  end
  
end
