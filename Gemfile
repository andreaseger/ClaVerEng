# A sample Gemfile
source "https://rubygems.org"

# database
gem 'activerecord', require: 'active_record'
gem 'activesupport', require: false
gem 'standalone_migrations'

# Preprocessor & Selectors
gem 'svm_helper', '~>0.0.7', github: 'sch1zo/svm_helper'

# Trainer
gem 'svm_trainer', '>=0.1.6', git: 'git@github.com:sch1zo/svm_trainer.git'

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  # gem 'activerecord-jdbcsqlite3-adapter'
  gem "jrb-libsvm", '>=0.1.1', github: 'sch1zo/jrb-libsvm', require: 'jrb-libsvm'
end
platforms :ruby do
  gem 'pg'
  # gem 'sqlite3'
  gem "rb-libsvm", '>=1.1.1',  github: 'sch1zo/rb-libsvm', require: 'libsvm'
end

group :test, :development do
  gem 'yard'
  gem 'kramdown'
  gem 'github-markup'

  gem 'pry'
  gem 'guard-rspec'
  gem 'guard-yard'

  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'rake'
  gem 'mocha', require: 'mocha/api'
end

