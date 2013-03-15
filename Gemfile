# A sample Gemfile
source "https://rubygems.org"

# database
gem 'sequel'

# Preprocessor & Selectors
gem 'svm_helper', '>= 0.1.1'

# Trainer
gem 'svm_trainer', '~>0.1.10', github: 'sch1zo/svm_trainer'

# Predictor
gem 'svm_predictor', '~>0.0.2', git: 'git@github.com:sch1zo/svm_predictor.git'

# platforms :jruby do
#   gem 'activerecord-jdbcpostgresql-adapter'
#   gem 'activerecord-jdbcsqlite3-adapter'
#   gem "jrb-libsvm", '~>0.1.2'
#   # gem "jrb-libsvm", '~>0.1.2', github: 'sch1zo/jrb-libsvm', require: 'jrb-libsvm'
# end
platforms :ruby do
  gem 'pg'
  # gem 'sequel_pg'
  gem "rb-libsvm", '~>1.1.2',  github: 'sch1zo/rb-libsvm', require: 'libsvm'
end

group :test, :development do
  gem 'yard'
  gem 'kramdown'
  gem 'github-markup'

  gem 'pry'
  gem 'guard-rspec'
  gem 'guard-yard'

  gem 'rb-inotify', '~> 0.9', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'rake'
  gem 'mocha', require: 'mocha/api'
end

