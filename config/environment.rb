# load bundler and all bundler gems
require 'bundler'

ROOT ||= File.join(File.dirname(__FILE__), '..')
rack_env = ENV['RACK_ENV'] || :development

Bundler.setup
Bundler.require(:default, rack_env)
# print "#{rack_env}\n"

# load config
%w(database.yml settings.yml).each do |f|
  unless File.exists? File.join(ROOT, 'config', f)
    require 'fileutils'
    FileUtils.cp File.join(ROOT, 'config', "#{f}.example"), File.join(ROOT, 'config', f)
    puts "[INFO] #{f} created from sample"
  end
end

# load models
Dir[File.join(ROOT, 'lib', 'models','*.rb')].each {|m| require m}

# connect to database
require 'logger'
#ActiveRecord::Base.logger = Logger.new("log/#{rack_env.to_s}.log")
#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(rack_env)

require 'svm_toolkit'
include SvmToolkit