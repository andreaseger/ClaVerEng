require 'celluloid'
module Trainer
  class Base
    DEFAULT_NUMBER_OF_FOLDS = 3
    attr_accessor :number_of_folds
    attr_accessor :results
    attr_accessor :costs
    attr_accessor :gammas
    attr_accessor :evaluator
    def initialize args
      @results = {}
      @costs = args.fetch(:costs) { -5..15 }
      @gammas = args.fetch(:gammas) { -15..9 }
      @evaluator = args.fetch(:evaluator, Evaluator::OverallAccuracy)
      @number_of_folds = args.fetch(:number_of_folds) { DEFAULT_NUMBER_OF_FOLDS }
    end

    def make_folds feature_vectors
      *folds,_ = feature_vectors.each_slice(feature_vectors.size/number_of_folds).map do |set|
                   Problem.from_array(set.map(&:data), set.map(&:label))
                 end
      folds
    end

    def collect_futures futures
      # init a hash which automatically expands to something like {a:[], b:[]}
      values = Hash.new { |h, k| h[k] = [] }
      futures.map { |f|
        model, result = f.value
        values[cost: model.cost, gamma: model.gamma] << result
      }
      # calculate means for each parameter pair
      values.map!{|k,v| {k => v.instance_eval { reduce(:+) / size.to_f }}}
      # flatten array of hashed into one hash
      Hash[*values.map(&:to_a).flatten]
    end
    private
    def train_svm feature_vector, cost, gamma
      feature_set = Problem.from_array(feature_vectors.map(&:data),
                                       feature_vectors.map(&:label))
      Svm.svm_train(train, Parameter.new( :svm_type => Parameter::C_SVC,
                                          :kernel_type => Parameter::RBF,
                                          :cost => cost,
                                          :gamma => gamma) )
    end
  end

  class Worker
    include Celluloid
    def initialize args={}
      @evaluator = args[:evaluator]
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