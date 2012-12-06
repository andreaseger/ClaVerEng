include Rake::DSL

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

# If you want to make this the default task
task :default => :spec