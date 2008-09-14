require 'fileutils'
require 'rubygems'
require 'rake/testtask'
require 'ftools'
require 'database'
include FileUtils

task :default => :test

desc "Run tests"
task :test => :dbinit do |t|
  Rake::TestTask.new do |t|
    t.test_files = FileList['*test*.rb']
    t.verbose = true
  end
end

desc "create the db schema"
task :dbinit do |t|
  Database.test_connect
  Database.disconnect
end
