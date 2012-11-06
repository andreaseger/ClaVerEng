require 'bundler'
Bundler.setup
Bundler.require(:default, :test)
$:.unshift File.expand_path("../lib",__FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
end