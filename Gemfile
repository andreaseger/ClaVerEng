# A sample Gemfile
source "https://rubygems.org"

gem 'rake'

# database
gem 'activerecord', require: 'active_record'

gem 'activerecord-jdbcpostgresql-adapter', platform: :jruby
gem 'svm_toolkit', git: 'https://github.com/sch1zo/svm_toolkit.git', branch: 'restructure', require: false, platform: :jruby



group :test, :development do
  gem 'pry'
  gem 'guard-rspec'
  # gem 'guard-jruby-rspec', git: 'git://github.com/jkutner/guard-jruby-rspec.git'
  # gem 'guard-shell'

  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'mocha', require: 'mocha_standalone'
  gem 'factory_girl', '~> 4.0'
end
