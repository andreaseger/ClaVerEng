require_relative 'config/environment'
require_relative 'lib/contour_display'
require_relative 'lib/preprocessor/simple.rb'
require_relative 'lib/selector/simple.rb'

class Engine
  attr_accessor :preprocessor
  attr_accessor :selector
  def initialize *args
    preprocessor = args.fetch(:preprocessor, SimplePreprocessor).new
    selector = args.fetch(:selector, SimpleSelector).new
  end

  def run
    jobs = Job.checked.with_language(5)
    data = preprocessor.run(jobs)
    feature_sets = selector.run(data)

    training_set, cross_set, test_set, _ = feature_sets.each_slice(job.size/3).to_a

    costs = [-5, -3, -1, 0, 1, 3, 5, 8, 10, 13, 15].collect {|n| 2**n}
    gammas = [-15, -12, -8, -5, -3, -1, 1, 3, 5, 7, 9].collect {|n| 2**n}

    p "cross_validation_search"
    model, results = Svm.cross_validation_search(training_set, cross_set, costs, gammas)

    results.sort_by!{|r| [r[:gamma], r[:cost]] }
    ContourDisplay.new(costs.collect {|n| Math.log2(n)}, 
                       gammas.collect {|n| Math.log2(n)}, 
                       results.map{|r| r[:result]})
  end
end


engine = Engine.new preprocessor: MegaPreprocessor, selector: SimpleSelector

# use setting from Instancecreation
engine.run
# use run specific settings
# engine.run preprocessor: AdvancedPreprocessor, selector: SimpleSelector