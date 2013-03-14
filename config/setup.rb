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
  DB = Sequel.connect(JSON.parse(IO.read(config))['sequel-uri'], loggers: [Logger.new($stdout)])
else
  puts <<-EOF.gsub(/^ {4}/,'')
    no #{config} file found
    should contain content similar to:
    {
      "sequel-uri": "postgres://username:password@host:port/database"
    }
  EOF
end

