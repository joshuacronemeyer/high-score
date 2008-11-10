require 'rubygems'
require 'active_record'
require 'logger'
require 'fileutils'
include FileUtils

class Database
  
  SCHEMA_FILE = 'schema.rb'
  ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))
  ActiveRecord::Base.colorize_logging = false

  def self.connect    
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      #:dbfile => ':memory:'
      :dbfile => 'highscores' 
    ) unless ActiveRecord::Base.connected?
  end

  def self.connect_mysql
    ActiveRecord::Base.establish_connection(
      :adapter => 'mysql',
      :host => 'deb-vm',
      :database => 'highscores',
      :username => 'josh'
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
