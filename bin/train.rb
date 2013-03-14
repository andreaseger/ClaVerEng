#!/usr/bin/env ruby

require 'optparse'

options={}
optparse = OptionParser.new do |opts|
  
  opts.on( "-a", "--gamma GAMMA", Float, "Gamma. for RBF Kernel" ) do |opt|
    options[:gamma] = opt
  end
  opts.on( "-o", "--cost COST", Float, "Cost." ) do |opt|
    options[:cost] = opt
  end
  opts.on( "-l", "--log2", "Gamma/Cost are log2(real_value)." ) do |opt|
    options[:log2] = true
  end

  opts.on( "-p", "--preprocessor NAME", "Which Preprocessor to use. [Simple]" ) do |opt|
    options[:preprocessor] = opt.downcase.to_sym
  end
  opts.on( "-s", "--selector NAME", "Which Selector to use. [Simple]" ) do |opt|
    options[:selector] = opt.downcase.to_sym
  end
  opts.on( "-g", "--gram SIZE", Integer, "n-gram size." ) do |opt|
    options[:gram_size] = opt.to_i
  end
  opts.on( "-n", "--max_samplesize SIZE", Integer, "max number of jobs to use." ) do |opt|
    options[:max_samplesize] = opt
  end
  opts.on( "-d", "--dictionary-size SIZE", Integer,
                 "Number of unique words in the dictionary" ) do |opt|
    options[:dictionary_size] = opt
  end
  options[:classification] = :function
  opts.on( "-c", "--classification CLASSIFICATION", String,
                 "One of [*function*, industry, career_level]" ) do |opt|
    options[:classification] = opt.downcase.to_sym
  end

  opts.on( '-?', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

require './config/setup'
require './lib/runner/train'

runner = Runner::Train.new

runner.train(options)