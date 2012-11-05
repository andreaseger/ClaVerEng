ENV['RACK_ENV'] = :test
require 'environment'

RSpec.configure do |config|
  config.mock_with :mocha
end