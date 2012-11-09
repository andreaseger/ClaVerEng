require 'bundler'
Bundler.setup
Bundler.require(:default, :test)

RSpec.configure do |config|
  config.mock_with :mocha

  FactoryGirl.find_definitions
end
