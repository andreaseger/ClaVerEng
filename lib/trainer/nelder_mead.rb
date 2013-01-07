require 'celluloid'
require_relative 'base'
require_relative 'worker'
module Trainer

  class ParameterSet
    attr_accessor :gamma, :cost
    attr_accessor :result
    def initialize(gamma, cost)
      @gamma = gamma
      @cost = cost
    end
    def +(other)
      new(self.gamma + other.gamma, self.cost + other.cost)
    end
    def -(other)
      new(self.gamma - other.gamma, self.cost - other.cost)
    end
    def *(other)
      case other
      when ParameterSet:
        new(self.gamma * other.gamma, self.cost * other.cost)
      else
        new(self.gamma * other, self.cost * other)
      end
    end
    def <=>(other)
      result(self) <=> result(other)
    end
    def key
      [gamma, cost]
    end
    def params_hash
      {gamma: gamma, cost: cost}
    end
  end
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
      while !done?
        best, worse, worst = order
        center = [best,worse].transpose.map{|e| e.inject(&:+)/e.length.to_f}
        reflection = reflect center, worst
        case
        when best >= reflection && reflection >= worse
          worst = reflection
        when reflection > best
          expansion = expand center, worst
          if expansion > reflection
            worst = expansion
          else
            worst = reflection
          end
        when reflection < worse
          contraction = if reflection < worst
                          contract_outside(center, worst)
                        else
                          contract_inside(center, worst)
                        end
          if contraction > worst
            worst = contraction
          else
            worse, worst = [worse, worst].map { |e| contract_inside(best, e) }
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

    def initial_simplex(x1=ParameterSet.new(0,0),c=5)
      p= c/Math.sqrt(2) * (Math.sqrt(3)-1)/2
      q= ParameterSet.new(p,p)
      x2 = x1 + q + c/Math.sqrt(2) * ParameterSet.new(1,0)
      x3 = x1 + q + c/Math.sqrt(2) * ParameterSet.new(0,1)
      @simplex = [x1,x2,x3]
    end

    def order
      @simplex.each { |e| e.results = func(e) } # calculate results
      @simplex.sort!
      return [ @simplex[0], @simplex[-2], @simplex[-1] ]
    end

    def reflect(center, worst, alpha=1)
      #center.map.with_index{|e,i| e + alpha * ( e - worst[i] )} # version for simple arrays
      p = center + alpha * ( center - worst )
      p.result = func(p)
      p
    end

    def expand(center, worst, beta=2)
      reflection center, worst, beta
    end

    def contract_outside(center, worst, gamma=0.5)
      reflection center, worst, gamma
    end

    def contract_inside(center, worst, gamma=0.5)
      p = center + gamma * ( worst - center )
      p.result = func(p)
      p
    end

    TOLERANCE=10**-8
    # def done?
    #   @simplex.permutation(2).map { |e| (e[0]-e[1]).abs <= TOLERANCE }.all?
    # end
    def done?
      _f = 1/3 * @simplex.map(&:result).inject(&:+)
      _d = 1/3 * @simplex.map{ |e| (e.result - _f)**2 }.inject(&:+)
      _d <= TOLERANCE**2
    end
    def func parameter_set
      unless @func.has_key? parameter_set.key
        futures=[]
        # n-fold cross validation
        @folds.each.with_index do |fold,index|
          # start async SVM training  | ( trainings_set, parameter, validation_sets)
          futures << @worker.future.train( fold, parameter_set.params_hash,
                                           folds.select.with_index{|e,ii| index!=ii } )
        end
        # collect results - !blocking!
        # and add result to cache
        # TODO I think I have to convert/extract the specific result from collect_results
        @func[parameter_set.key] = collect_results(futures)
      end
      @func[parameter_set.key]
    end
  end
end