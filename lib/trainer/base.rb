require 'celluloid'
module Trainer
  class Base
    attr_accessor :number_of_folds
    def initialize(args)
      self.number_of_folds = args.fetch(:folds) { DEFAULT_NUMBER_OF_FOLDS }
    end
  end
  class Worker
    include Celluloid
    def initialize args={}
      @evaluator = args[:evaluator]
      @parameter = 
    end
    def train train, parameter, folds
      svm_parameter = Parameter.new(:svm_type => Parameter::C_SVC,
                                    :kernel_type => Parameter::RBF,
                                    :cost => parameter[:cost],
                                    :gamma => parameter[:gamma])
      evaluate Svm.svm_train(train, parameter), folds
    end
    def evaluate model, folds
      result = folds.map{ |fold|
        model.evaluate_dataset(fold, :evaluator => @evaluator)
      }.reduce(&:+) / folds.count
      return [model, results]
    end
  end
end