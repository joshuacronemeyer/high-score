require 'active_record'

class Machine < ActiveRecord::Base
  has_many :score
  has_many :grudge_match

  def is_grudge_match_machine?
    return self.grudge_match.size > 0
  end
end
