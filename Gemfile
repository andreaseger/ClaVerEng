# A sample Gemfile
source "https://rubygems.org"

gem 'rake'

# database
gem 'activerecord', require: 'active_record'
gem 'activerecord-jdbcpostgresql-adapter'

gem 'svm_toolkit', git: 'https://github.com/sch1zo/svm_toolkit.git', branch: 'restructure'

group :test, :development do
  gem 'pry'
  gem 'guard-rspec'
end

group :test do
  gem 'mocha', require: 'mocha_standalone'
end

