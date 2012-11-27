require 'celluloid'
require_relative 'doe_pattern'
module Trainer
  class DoeHeuristic < Base
    include DoePattern
    attr_accessor :results
    # attr_accessor :resolution
    attr_accessor :costs
    attr_accessor :gammas
    attr_accessor :evaluator
    def initialize args
      super
      @results = {}
      @costs = args.fetch(:costs) { -5..15 }
      @gammas = args.fetch(:gammas) { -15..9 }
      @evaluator = args.fetch(:evaluator, Evaluator::OverallAccuracy)
    end

    def make_folds feature_vectors, n
      feature_vectors.each_slice(feature_vectors.size/n).map do |set|
        Problem.from_array(set.map(&:data), set.map(&:label))
      end
    end
    def search(args={})
      # deal with input
      feature_vectors = args[:feature_vectors]
      max_iterations = args.fetch(:interations) { 1 }

      # split feature_vectors into folds
      *folds,_ = make_folds(feature_vectors, n)

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
        new_results = Hash.new { |h, k| h[k] = [] }
        futures.map { |f|
          result = f.value
          new_results[cost: model.cost, gamma: model.gamma] << result
        }
        # calculate means for each parameter pair
        new_results = new_results.map{|k,v| {k => v.instance_eval { reduce(:+) / size.to_f }}}
        new_results = Hash[*mean_results.map(&:to_a).flatten]

        results.merge new_results

        # get the pair with the best value
        best = results.invert[results.values.max]

        # get new search window
        parameter, resolution = pattern_for_center best, resolution.map{|e| e/Math.sqrt(2)}, [costs, gammas]
      end

      best_parameter = results.invert[results.values.max]
      # retrain the model with the best results and all of the available data
      feature_set = Problem.from_array(feature_vectors.map(&:data), feature_vectors.map(&:label))
      model = Svm.svm_train(train, Parameter.new(:svm_type => Parameter::C_SVC,
                                                :kernel_type => Parameter::RBF,
                                                :cost => best_parameter[:cost],
                                                :gamma => best_parameter[:gamma]))
      return model, results
    end
  end
end