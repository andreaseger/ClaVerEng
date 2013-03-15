# load bundler and all bundler gems
require 'bundler'

ROOT ||= File.join(File.dirname(__FILE__), '..')
rack_env = ENV['RACK_ENV'] || :development

Bundler.setup
Bundler.require(:default, rack_env)
print "#{rack_env}\n"

require 'logger'
#TODO load this from a file
config = File.join(ROOT,'config','settings.json')
if File.exists? config
  SETTINGS = JSON.parse(IO.read(config))
  #DB = Sequel.connect(SETTINGS['sequel-uri'], loggers: [Logger.new($stdout)])
else
  puts <<-EOF.gsub(/^ {4}/,'')
    no settings file found
    have a look at config settings.json.example
  EOF
end

