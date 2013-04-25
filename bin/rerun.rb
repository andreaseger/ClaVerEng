#!/usr/bin/env ruby

require 'optparse'
options={}
optparse = OptionParser.new do |opts|
  opts.on( "-p", "--predictor FILE", String, "path to predictor file." ) do |opt|
    options[:predictor] = opt
  end
  opts.on( "-n", "--samplesize SIZE", Integer, "number of jobs to use." ) do |opt|
    options[:samplesize] = opt
  end
  options[:git]=true
  opts.on( "-b", "--no-git", "don't make a commit for the results" ) do |opt|
    options[:git]=false
  end

  opts.on( "--distribution N", Numeric, "distribution between true and false jobs(defaults to 1:1)\n3 means 3 times as much false one as true ones.") do |opt|
    options[:distribution] = opt
  end
  opts.on( "--id ID", Numeric, "set the id for the new predictor.") do |opt|
    options[:id] = opt
  end

  options[:pretty]=false
  opts.on("--pretty", "pretty print predictor json") do
    options[:pretty]=true
  end
  opts.on( '-?', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'config/setup'
require 'lib/runner/rerun'

#runner = Runner::Single.new(pretty: options[:pretty])
runner = Runner::Rerun.new(pretty: true)

runner.run(options[:predictor], options)
