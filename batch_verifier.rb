require_relative 'config/environment'
require_relative 'lib/runner/batch'

runner = Runner::Batch.new preprocessor: :simple,
                                          selectors: [:simple, :ngram],
                                          trainers: [:linear, :grid],
                                          classifications: :industry,
                                          dictionary_sizes: 400,
                                          samplesizes: [800]

runner.batch
