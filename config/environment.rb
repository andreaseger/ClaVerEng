# load bundler and all bundler gems
require 'bundler'

ROOT ||= File.join(File.dirname(__FILE__), '..')
rack_env = ENV['RACK_ENV'] || :development

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

# load models
Dir[File.join(ROOT, 'lib', 'models','*.rb')].each {|m| require m}

# connect to database
require 'logger'
#ActiveRecord::Base.logger = Logger.new("log/#{rack_env.to_s}.log")
#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.configurations = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection(rack_env)

require 'svm_toolkit'
include SvmToolkit