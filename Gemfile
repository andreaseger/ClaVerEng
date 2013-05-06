# A sample Gemfile
source "https://rubygems.org"

# database
gem 'sequel'

gem 'activesupport', require: 'active_support/core_ext'

# Preprocessor & Selectors
# gem 'svm_helper','>= 0.2.1', github: 'sch1zo/svm_helper'
gem 'svm_helper', '>= 0.2.1'
gem 'parallel'

# Trainer
gem 'svm_trainer', '>= 0.2.0.pre', github: 'sch1zo/svm_trainer'

# Predictor
gem 'svm_predictor', '>= 0.1.1', git: 'git@github.com:sch1zo/svm_predictor.git'

platforms :ruby do
  gem 'pg'
  #gem "rb-libsvm", '>= 1.1.2',  github: 'sch1zo/rb-libsvm', branch: 'with_libsvm_output', require: 'libsvm'
  gem "rb-libsvm", '>= 1.1.2',  github: 'sch1zo/rb-libsvm', require: 'libsvm'
end

group :test, :development do
  gem 'yard'
  gem 'kramdown'
  gem 'github-markup'

  gem 'pry'
  gem 'pry-nav'
#  gem 'pry-stack_explorer'
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

