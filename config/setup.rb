# load bundler and all bundler gems
require 'bundler'

ROOT ||= File.join(File.dirname(__FILE__), '..')
rack_env = ENV['RACK_ENV'] || :development

Bundler.setup
Bundler.require(:default, rack_env)
print "#{rack_env}\n"

#TODO load this from a file
if File.exists? './settings.json'
  DB = Sequel.connect(JSON.parse(IO.read('./settings.json')))
else
  puts <<-EOF.gsub(/^ {4}/,'')
    no settings.json file found
    should contain content similar to:
    {
      "sequel-uri": "postgres://username:password@host:port/database"
    }
  EOF
end

