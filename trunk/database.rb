require 'rubygems'
require 'active_record'
require 'fileutils'
include FileUtils

class Database
  
  SCHEMA_FILE = 'schema.rb'
  
  def self.connect    
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :dbfile => ':memory:'
      #:dbfile => 'highscores' 
    ) unless ActiveRecord::Base.connected?
  end
  
  def self.disconnect
    ActiveRecord::Base.remove_connection() if ActiveRecord::Base.connected?
  end
  
  def self.test_connect
    connect
    load_schema
  end

  def self.load_schema
    load SCHEMA_FILE
  end
  
end
