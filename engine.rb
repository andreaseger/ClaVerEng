require_relative 'config/environment'
require_relative 'lib/contour_display'
require_relative 'lib/preprocessors/simple.rb'
require_relative 'lib/selectors/simple.rb'
require 'pry'

class Engine
  attr_accessor :preprocessor
  attr_accessor :selector
  def initialize args={}
    self.preprocessor = args.fetch(:preprocessor, Preprocessor::Simple).new
    self.selector = args.fetch(:selector, Selector::Simple).new
  end

  def run args={}
    start = Time.now
    sample_size = args.fetch(:sample_size,5000)

    jobs = Job.checked.with_language(5).limit(sample_size)
    p "preprocessing..."
    data = @preprocessor.process(jobs);jobs=nil
    p "creating feature vectors..."
    feature_vectors = @selector.generate_vectors(data)

    training_set,
    cross_set,
    test_set, _ = feature_vectors.each_slice(data.size/3).map{|set|
      Problem.from_array(set.map(&:data), set.map(&:checked_correct))
    }
    feature_vectors=nil;data=nil

    costs = [-5, -3, -1, 0, 1, 3, 5, 8, 10, 13, 15].collect {|n| 2**n}
    gammas = [-15, -12, -8, -5, -3, -1, 1, 3, 5, 7, 9].collect {|n| 2**n}

    p "cross_validation_search"
    model, results = Svm.cross_validation_search(training_set, cross_set, costs, gammas)

    results.sort_by!{|r| [r[:gamma], r[:cost]] }
    results_matrix = results.map{|e| e[:result].value}.each_slice(costs.size).to_a
    ContourDisplay.new(costs.collect {|n| Math.log2(n)}, 
                       gammas.collect {|n| Math.log2(n)}, 
                       results_matrix)
    p "GeometricMean on test_set: #{model.evaluate_dataset(test_set, :evaluator => Evaluator::GeometricMean)}"

    p "Time: #{Time.now - start} seconds"
    timestamp = Time.now.strftime('%Y-%m-%dT%l:%M')
    model.save "tmp/#{timestamp}-model"
    IO.write "tmp/#{timestamp}-dictionary", @selector.global_dictionary
  end
end


engine = Engine.new preprocessor: Preprocessor::Simple, selector: Selector::Simple

# use setting from Instancecreation
engine.run
# use run specific settings
# engine.run preprocessor: AdvancedPreprocessor, selector: SimpleSelector