#!/usr/bin/env ruby

require 'optparse'

options={}
optparse = OptionParser.new do |opts|
  opts.on( "-p", "--preprocessor NAME", "Which Preprocessor to use. [Simple,IDMapping]" ) do |opt|
    options[:preprocessor] = opt.downcase.to_sym
  end

  opts.on( "-s", "--selector NAME", "Which Selector to use. [simple,ngram,binary_encoded]" ) do |opt|
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

  opts.on( '-?', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'config/setup'
require 'lib/runner/single'

runner = Runner::Single.new

runner.run(options[:preprocessor], options[:selector], options[:trainer], options)
