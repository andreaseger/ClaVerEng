require 'optparse'
require_relative 'lib/preprocessors/simple'
require_relative 'lib/selectors/simple'

options={}
optparse = OptionParser.new do |opts|
  opts.on( "-g", "--plot", "Show a plot of the results" ) do |opt|
    options[:plot] = true
  end

  options[:preprocessor] = Preprocessor::Simple
  opts.on( "-p", "--preprocessor NAME", "Which Preprocessor to use. [Simple]" ) do |opt|
    options[:preprocessor] =  case opt
                              when 'simple'
                                Preprocessor::Simple
                              else
                                Preprocessor::Simple
                              end
  end
  options[:selector] = Selector::Simple
  opts.on( "-s", "--selector NAME", "Which Selector to use. [Simple]" ) do |opt|
    options[:selector] =  case opt
                          when 'simple'
                            Selector::Simple
                          else
                            Selector::Simple
                          end
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
                 "One of [*function*, industry, careerlevel]" ) do |opt|
    options[:classification] = opt.downcase.to_sym
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
                    selector: options[:selector]

# use setting from Instancecreation
runner.run(options)
# use run specific settings
# engine.run preprocessor: AdvancedPreprocessor, selector: SimpleSelector