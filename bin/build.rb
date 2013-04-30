#!/usr/bin/env ruby

require 'optparse'

options={}
optparse = OptionParser.new do |opts|
  opts.on( '-?', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
  options[:run] = 'build.yml'
  opts.on( "-r", "--run", String, "run setup" ) do |opt|
    options[:run] = opt
  end
end
optparse.parse!

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'config/setup'
require 'lib/runner/single'


run_setups = YAML.load(IO.read(options[:run]))
run_setups.delete("_defaults")

run_setups.each { |language, v|
  v.each { |classification, setups|
    setups.each do |params|
      runner = Runner::Single.new(pretty: true)
      runner.classification = classification
      runner.language = language
      runner.run(params[:preprocessor],
                 params[:selector],
                 params[:trainer],
                 params)
    end
  }
}
