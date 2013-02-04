require_relative 'config/environment'
require_relative 'lib/runner/batch'

runner = Runner::Batch.new preprocessor: :simple,
                                          selectors: [:simple, :ngram],
                                          trainers: [:linear, :grid],
                                          classifications: :career_level,
                                          dictionary_size: 400

runner.batch
