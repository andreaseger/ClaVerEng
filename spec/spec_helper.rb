require 'bundler'
Bundler.setup
Bundler.require(:default, :test)
print `rvm current`

RSpec.configure do |config|
  config.mock_with :mocha
end
