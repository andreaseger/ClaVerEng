require_relative 'config/setup'
require_relative 'lib/runner/batch'

runner = Runner::Batch.new  preprocessor: :simple,
                            selectors: [:simple, :ngram],
                            trainers: [:grid, :nelder_mead],
                            classifications: [:function, :industry, :career_level],
                            dictionary_sizes: [600,800],
                            samplesizes: [600,800,1000,1200,1400]

meh = runner.batch
