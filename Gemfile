# A sample Gemfile
source "https://rubygems.org"

gem 'rake'

# database
gem 'activerecord', require: 'active_record'
gem 'activesupport', require: false
gem 'standalone_migrations'

gem 'celluloid'

# Preprocessor & Selectors
gem 'svm_helper', git: 'git://github.com/sch1zo/svm_helper.git'

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'svm_toolkit',  git: 'https://github.com/sch1zo/svm_toolkit.git',
                      branch: 'restructure',
                      require: false

  # gem 'svm_toolkit',  git: '/home/aeger/master/svm_toolkit',
  #                     branch: 'restructure',
  #                     require: false
end
platforms :ruby do
  gem 'pg'
end

#gem 'nokogiri'

group :test, :development do
  gem 'yard'
  gem 'kramdown'
  gem 'github-markup'

  gem 'pry'
  gem 'guard-rspec'
  gem 'guard-yard'

  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'mocha', require: 'mocha/api'
  gem 'factory_girl', '~> 4.0'
end

