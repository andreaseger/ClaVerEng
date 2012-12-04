require 'optparse'

options={}
optparse = OptionParser.new do |opts|
  opts.on( "-p", "--preprocessor NAME", "Which Preprocessor to use. [Simple]" ) do |opt|
    options[:preprocessor] = opt.downcase.to_sym
  end

  opts.on( "-s", "--selector NAME", "Which Selector to use. [Simple]" ) do |opt|
    options[:selector] = opt.downcase.to_sym
  end
  opts.on( "-n", "--samplesize SIZE", Integer, "Number of jobs to use." ) do |opt|
    options[:samplesize] = opt
  end
  opts.on( "-d", "--dictionary-size SIZE", Integer,
                 "Number of unique words in the dictionary" ) do |opt|
    options[:dictionary_size] = opt
  end

  options[:classification] = :function
  opts.on( "-c", "--classification CLASSIFICATION", String,
                 "One of [*function*, industry, career_level, all]" ) do |opt|
    options[:classification] = opt.downcase.to_sym
  end

  opts.on( "-t", "--trainer TRAINER", String, "either *doe* or *grid*" ) do |opt|
    options[:trainer] = opt.downcase.to_sym
  end
  opts.on( '-?', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

require_relative 'config/environment'
require_relative 'lib/runner'

p options
runner = Runner.new preprocessor: options[:preprocessor],
                    selector: options[:selector],
                    trainer: options[:trainer]

runner.run(options)
# use run specific settings
# engine.run preprocessor: AdvancedPreprocessor, selector: SimpleSelector
