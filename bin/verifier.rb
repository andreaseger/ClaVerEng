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
  opts.on( "-g", "--gram-size SIZE", Integer, "n-gram size." ) do |opt|
    options[:gram_size] = opt.to_i
  end
  opts.on( "-n", "--samplesize SIZE", Integer, "number of jobs to use." ) do |opt|
    options[:samplesize] = opt
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

  options[:git]=true
  opts.on( "-b", "--no-git", "don't make a commit for the results" ) do |opt|
    options[:git]=false
  end

  options[:evaluator] = :normalized_mcc
  opts.on( "-e", "--evaluator EVAL", "Which evaluator to use during parameter search") do |opt|
    options[:evaluator] = opt
  end
  opts.on( "--word-selection SETTING", String, "one of grams1_2, grams1_2_3, grams1_2_3_4") do |opt|
    options[:word_selection] = opt.to_sym
  end
  opts.on( "--number-of-folds SETTING", Numeric, "number of folds to use in cross-valication; default = 3; 1 => disables cross-validation") do |opt|
    options[:number_of_folds] = opt
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
require 'lib/runner/single'

#runner = Runner::Single.new(pretty: options[:pretty])
runner = Runner::Single.new(pretty: true)

runner.run(options[:preprocessor], options[:selector], options[:trainer], options)
