# load bundler and all bundler gems
require 'bundler'

ROOT ||= File.join(File.dirname(__FILE__), '..')
rack_env = ENV['RACK_ENV'] || :development

Bundler.setup
Bundler.require(:default, rack_env)
#print "#{rack_env}\n"

#TODO load this from a file
config_path = File.join(ROOT,'config','settings.json')
if File.exists? config_path
  SETTINGS = JSON.parse(IO.read(config_path))
  # correctly set the basedir relative to the config file
  SETTINGS['basedir'] = File.realdirpath File.join(File.dirname(config_path), SETTINGS['basedir'])
  #DB = Sequel.connect(SETTINGS['sequel-uri'], loggers: [Logger.new($stdout)])
else
  puts <<-EOF.gsub(/^ {4}/,'')
    no settings file found
    have a look at config settings.json.example
  EOF
end

