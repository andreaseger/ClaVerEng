require 'celluloid'
require_relative 'base'
module Trainer
  class GridSearch < Base
   def search(args={})
      # deal with input
      feature_vectors = args[:feature_vectors]

      # split feature_vectors into folds
      *folds,_ = make_folds feature_vectors

      # create Celluloid Threadpool
      worker = Worker.pool(args: [{evaluator: @evaluator}] )

      futures = []
      @gammas.each do |gamma|
        @costs.each do |cost|
          futures << worker.future.train( fold, {:cost => cost, :gamma => gamma},
                                          folds.select.with_index{|e,ii| index!=ii }
                                        )
        end
      end

      # collect results
      results = collect_futures(futures)

      # get the pair with the best value
      best_parameter = results.invert[results.values.max]

      model = train_svm feature_vectors, *best_parameter.values
      return model, results
    end
  end
end