require 'rubygems'
begin
  #if we have our own active record, use it!
  require 'active_record'
rescue LoadError
  #if not we come prepared.
  require 'lib/activerecord/lib/active_record'
  require 'lib/activesupport/lib/active_support'
end
require 'fileutils'
include FileUtils

class Database
  
  SCHEMA_FILE = 'schema.rb'
  
  def self.connect    
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :dbfile => ':memory:'
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
