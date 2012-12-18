require_relative 'config/environment'
require_relative 'lib/runner'

sample_sizes = dictionary_sizes = [500,800,1000,1500,2000,2500,3000]
selectors = [:simple, :ngram]
preprocessors = [:simple]
trainer = [:grid, :linear]

runner = Runner.new

sample_sizes.product(dictionary_sizes).product(selectors).product(preprocessors).product(trainer).map(&:flatten).each do |params|
  options = { trainer: params[4],
              folds: 3,
              classification: :all
              samplesize: params[0],
              dictionary_size: params[1],
              selector: params[2],
              preprocessor: params[3]}
  runner.run(options)
end