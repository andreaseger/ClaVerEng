require_relative 'config/environment'
require_relative 'lib/runner'

sample_sizes = dictionary_sizes = [500,1000,2000,3000,4000,5000]
selectors = [:simple, :ngram]
preprocessors = [:simple]

runner = Runner.new

sample_sizes.product(dictionary_sizes).product(selectors).product(preprocessors).map(&:flatten).each do |params|
  options = { trainer: :grid,
              folds: 3,
              classification: :all
              samplesize: params[0],
              dictionary_size: params[1],
              selector: params[2],
              preprocessor: params[3]}
  runner.run(options)
end