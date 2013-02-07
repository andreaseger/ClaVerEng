require_relative 'config/environment'
require_relative 'lib/runner/batch'

runner = Runner::Batch.new preprocessor: :simple,
                                          selectors: [:simple],
                                          trainers: [:grid, :nelder_mead],
                                          classifications: [:function],
                                          dictionary_sizes: 600,
                                          samplesizes: 1000

meh = runner.batch
