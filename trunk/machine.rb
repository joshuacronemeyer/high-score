require 'active_record'

class Machine < ActiveRecord::Base
  has_many :score
end
