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
      parameter = build_parameter params
      evaluate Svm.svm_train(trainings_set, parameter), folds
    rescue
      #TODO find out why this happens, seems to be something with the trainings_set inside the libsvm training
      p "error on #{trainings_set}|#{params}"
      return nil
    end

    def evaluate model, folds
      result = folds.map{ |fold|
        model.evaluate_dataset(fold, :evaluator => @evaluator)
      }.map(&:value).reduce(&:+) / folds.count
      return [model, result]
    end
  end
end
