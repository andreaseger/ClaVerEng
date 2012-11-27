require 'celluloid'
require_relative 'base'
require_relative 'doe_pattern'
module Trainer
  class DoeHeuristic < Base
    include DoePattern
    def search feature_vectors, max_interations=1
      # split feature_vectors into folds
      folds = make_folds feature_vectors

      # initialize iteration parameters and resolution
      parameter, resolution = pattern_for_range costs, gammas

      # create Celluloid Threadpool
      worker = Worker.pool(args: [{evaluator: @evaluator}] )

      max_iterations.times do
        futures = []
        parameter.each do |cost, gamma|
          # was this parameter pair already tested?
          next if results.has_key?(cost: cost, gamma: gamma)

          # n-fold cross validation
          folds.each.with_index do |fold,index|
            # train SVM async             ( trainings_set, parameter, validation_sets)
            futures << worker.future.train( fold, {:cost => cost, :gamma => gamma},
                                            folds.select.with_index{|e,ii| index!=ii }
                                          )
          end
        end

        # collect results
        results.merge collect_futures(futures)

        # get the pair with the best value
        best = results.invert[results.values.max]

        # get new search window
        parameter, resolution = pattern_for_center best, resolution.map{|e| e/Math.sqrt(2)}, [costs, gammas]
      end

      best_parameter = results.invert[results.values.max]
      # retrain the model with the best results and all of the available data
      model = train_svm feature_vectors, *best_parameter.values
      return model, results
    end
  end
end