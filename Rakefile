require 'bundler'
require 'active_record'
require 'yaml'

task :default => :migrate

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('lib/db/database.yml')))
  ActiveRecord::Migrator.migrate('lib/db/migrate' )
end
