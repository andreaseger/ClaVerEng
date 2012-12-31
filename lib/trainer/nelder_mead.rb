require 'celluloid'
require_relative 'base'
require_relative 'worker'
require_relative 'doe_pattern'
module Trainer
  #
  # Trainer for a parmeter search using the Nelder-Mead Simplex heurisitc with the RBF kernel
  #
  # @author Andreas Eger
  #
  class NelderMead < Base
    # default number of iterations to use during parameter search
    DEFAULT_MAX_ITERATIONS=3
    def name
      "Nelder-Mead Simplex Heuristic with #{number_of_folds}-fold cross validation"
    end
    def label
      "nelder_mead"
    end

    def initialize args
      super
      @simplex = []
      @func = {}
    end

    #
    # perform a search on the provided feature vectors
    # @param  feature_vectors
    #
    # @return [model, results] trained svm model and the results of the search
    def search feature_vectors, max_iterations=DEFAULT_MAX_ITERATIONS
      # split feature_vectors into folds
      @folds = make_folds feature_vectors

      # create Celluloid Threadpool
      @worker = Worker.pool(args: [{evaluator: @evaluator}] )

      initial_simplex
      while true #TODO cancle clause missing
        best, worse, worst = order
        center = [best,worse].transpose.map{|e| e.inject(&:+)/e.length.to_f}
        reflection = reflection(center, worst)
        case
        when best <= reflection && reflection <= worse
          worst = reflection
        when reflection < best
          expansion = expansion(center, worst)
          if expansion < reflection
            worst = expansion
          else
            worst = reflection
          end
        when reflection > worse
          if reflection > worst
            contraction = contraction center, worst
          else
            contraction = reduction center, worst
          end
          if contraction < worst
            worst = contraction
          else
            #TODO contract to best
          end
        end
        @simplex = [best, worse, worst]
      end

      # get the pair with the best value
      best_parameter = results.invert[results.values.max]

      model = train_svm feature_vectors, best_parameter
      return model, results
    end

    private

    def initial_simplex
      #TODO
      @simplex = [[],[],[]]
    end

    def order
      #TODO check if a sort_by! exists
      @simplex = @simplex.sort_by{|e| func(e) }
      return [ @simplex[0], @simplex[-2], @simplex[-1] ]
    end

    def reflection(center, worst, alpha=1)
      center.map.with_index{|e,i| e + alpha * ( e - worst[i] )}
    end

    def expansion(center, worst, beta=2)
      reflection center, worst, beta
    end

    def contraction(center, worst, gamma=0.5)
      reflection center, worst, gamma
    end

    def reduction(center, worst, gamma=0.5)
      center.map.with_index{|e,i| e + gamma * ( worst[i] - e )}
    end

    def func params
      unless @func.has_key? params
        futures=[]
        # n-fold cross validation
        @folds.each.with_index do |fold,index|
          # start async SVM training  | ( trainings_set, parameter, validation_sets)
          futures << worker.future.train( fold, params,
                                          folds.select.with_index{|e,ii| index!=ii } )
        end
        # collect results - !blocking!
        # and add result to cache
        @func[params] = collect_results(futures)
      end
      @func[params]
    end
  end
end