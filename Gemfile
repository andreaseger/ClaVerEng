# A sample Gemfile
source "https://rubygems.org"

# database
gem 'activerecord', require: 'active_record'
gem 'activesupport', require: false
gem 'standalone_migrations'

# Preprocessor & Selectors
gem 'svm_helper', '~>0.0.10', github: 'sch1zo/svm_helper', branch: 'optimize_preprocessing', ref: 'b0bf47f'

# Trainer
gem 'svm_trainer', '~>0.1.8', github: 'sch1zo/svm_trainer', branch: 'removed_celluloid', ref: '3b5aa13'

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
  gem "jrb-libsvm", '>=0.1.1', github: 'sch1zo/jrb-libsvm', require: 'jrb-libsvm'
end
platforms :ruby do
  gem 'pg'
  gem 'sqlite3'
  gem "rb-libsvm", '>=1.1.2',  github: 'sch1zo/rb-libsvm', branch: 'openmp_svc', require: 'libsvm', ref: 'eeb772f'
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

