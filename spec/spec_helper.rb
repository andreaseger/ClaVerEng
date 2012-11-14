require 'bundler'
Bundler.setup
Bundler.require(:default, :test)
require 'rbconfig'
p "testing with #{RbConfig::CONFIG["prefix"]}"

RSpec.configure do |config|
  config.mock_with :mocha

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir["./spec/support/**/*.rb"].each {|f| require f}

  FactoryGirl.find_definitions
end
