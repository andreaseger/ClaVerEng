require 'bundler'
Bundler.setup
Bundler.require(:default, :test)
require 'rbconfig'
p "testing with #{RbConfig::CONFIG["prefix"]}"

RSpec.configure do |config|
  config.mock_with :mocha
  
  FactoryGirl.find_definitions
end
