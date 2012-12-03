require 'optparse'
require 'pry'
require_relative 'lib/preprocessors/simple'
require_relative 'lib/selectors/simple'
require_relative 'lib/trainer/doe_heuristic'
require_relative 'lib/trainer/grid_search'

options={}
optparse = OptionParser.new do |opts|
  opts.on( "-g", "--plot", "Show a plot of the results" ) do |opt|
    options[:plot] = true
  end

  opts.on( "-p", "--preprocessor NAME", "Which Preprocessor to use. [Simple]" ) do |opt|
    options[:preprocessor] = opt.downcase.to_sym
     case opt
                              when 'simple'
                                Preprocessor::Simple
                              else
                                Preprocessor::Simple
                              end
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

options[:trainer] = case options[:trainer]
                    when :doe
                      Trainer::DoeHeuristic
                    else
                      Trainer::GridSearch
                    end

options[:preprocessor] =  case options[:preprocessor]
                          when :simple
                            Preprocessor::Simple
                          else
                            Preprocessor::Simple
                          end
options[:selector] =  case options[:selector]
                      when :simple
                        Selector::Simple
                      else
                        Selector::Simple
                      end

require_relative 'config/environment'
require_relative 'lib/runner'

p options
runner = Runner.new preprocessor: options[:preprocessor],
                    selector: options[:selector],
                    show_plot: options[:plot],
                    trainer: options[:trainer]

runner.run(options)
# use run specific settings
# engine.run preprocessor: AdvancedPreprocessor, selector: SimpleSelector
