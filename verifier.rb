#!/usr/bin/env ruby

require 'optparse'

options={}
optparse = OptionParser.new do |opts|
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

  opts.on( "-t", "--trainer TRAINER", String, "either *grid*, *doe* or *nelder_mead* " ) do |opt|
    options[:trainer] = opt.downcase.to_sym
  end
  options[:verbose] = false
  opts.on( "-v", "--verbose", "print verbose output" ) do |opt|
    options[:verbose] = true
  end
  opts.on( '-?', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

require_relative 'config/setup'
require_relative 'lib/runner/single'

runner = Runner::Single.new(verbose: options[:verbose])

runner.run(options[:preprocessor], options[:selector], options[:trainer], options)
