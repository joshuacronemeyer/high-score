require 'active_record'

class Machine < ActiveRecord::Base
  has_many :score
  has_many :grudge_match
end
