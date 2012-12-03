require 'celluloid'
require_relative 'base'
module Trainer
  class GridSearch < Base
    def name
      "Grid Search with #{number_of_folds}-fold cross validation"
    end

    def search feature_vectors,_
      # split feature_vectors into folds
      folds = make_folds feature_vectors

      # create Celluloid Threadpool
      worker = Worker.pool(args: [{evaluator: @evaluator}] )

      futures = []
      @gammas.each do |gamma|
        @costs.each do |cost|
          params = {cost: 2**cost, gamma: 2**gamma}
          # n-fold cross validation
          folds.each.with_index do |fold,index|
            # start async SVM training  | ( trainings_set, parameter, validation_sets)
            futures << worker.future.train( fold, params,
                                            folds.select.with_index{|e,ii| index!=ii } )
          end
        end
      end

      # collect results - !blocking!
      results = collect_results(futures)

      # get the pair with the best value
      best_parameter = results.invert[results.values.max]

      model = train_svm feature_vectors, best_parameter[:cost], best_parameter[:gamma]
      return model, results
    end
  end
end