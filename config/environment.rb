# load bundler and all bundler gems
require 'bundler'

ROOT ||= File.join(File.dirname(__FILE__), '..')

Bundler.setup
Bundler.require(:default, rack_env)
# print "#{rack_env}\n"

# load config
%w(db/config.yml config/settings.yml).each do |f|
  unless File.exists? File.join(ROOT, f)
    require 'fileutils'
    FileUtils.cp File.join(ROOT, "#{f}.example"), File.join(ROOT, f)
    puts "[INFO] #{f} created from sample"
  end
end

# connect to database
require 'logger'
#ActiveRecord::Base.logger = Logger.new("log/#{rack_env.to_s}.log")
#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.configurations = YAML::load(IO.read(File.join(ROOT,'db/config.yml')))
ActiveRecord::Base.establish_connection(:pjpp_copy)

# load models
Dir[File.join(ROOT, 'lib', 'models','*.rb')].each {|m| require m}
