require 'celluloid'
require_relative 'helper'
module Trainer
  class Worker
    include Celluloid
    include Helper

    def initialize args={}
      @evaluator = args[:evaluator]
    end

    def train trainings_set, params, folds
      parameter = build_parameter params[:cost], params[:gamma]
      evaluate Svm.svm_train(trainings_set, parameter), folds
    end

    def evaluate model, folds
      result = folds.map{ |fold|
        model.evaluate_dataset(fold, :evaluator => @evaluator)
      }.reduce(&:+) / folds.count
      return [model, results]
    end
  end
end