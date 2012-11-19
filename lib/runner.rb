require_relative 'helper/grid_panel'
require_relative 'preprocessors/simple'
require_relative 'selectors/simple'
require 'benchmark'

class Runner
  attr_accessor :preprocessor
  attr_accessor :selector
  attr_accessor :panel

  COSTS = [-5, -3, -1, 0, 1, 3, 5, 8, 10, 13, 15].collect {|n| 2**n}
  GAMMAS = [-15, -12, -8, -5, -3, -1, 1, 3, 5, 7, 9].collect {|n| 2**n}

  def initialize args={}
    p args
    self.preprocessor = args.fetch(:preprocessor, Preprocessor::Simple).new
    self.selector = args.fetch(:selector, Selector::Simple).new
    if args[:show_plot]
      self.panel = GridPanel.new
    end
  end

  def run args={}
    @samplesize = args.fetch(:samplesize,5000)
    @dictionary_size = args.fetch(:dictionary_size,5000)
    classification = args.fetch(:classification, :function)
    jobs = [  Job.checked_correct.with_language(5).limit(@samplesize/2),
              Job.checked_faulty.with_language(5).limit(@samplesize/2)  ].flatten.shuffle
    p "preprocessing..."
    @data = @preprocessor.process(jobs)

    benchmark={}
    if classification == :all
      [:function, :industry, :career_level].each do |e|
        benchmark[e] = Benchmark.measure {run_for_classification(e)}
      end
    else
      benchmark[classification] = Benchmark.measure {run_for_classification(classification)}
    end

    benchmark.each do |k,v|
      print "#{k}: "
      puts v
    end
    panel.show!
  end
  def run_for_classification classification
    #TODO use benchmark package
    start = Time.now
    p "creating feature vectors for #{classification}..."
    feature_vectors = @selector.generate_vectors(@data,classification,@dictionary_size)

    training_set,
    cross_set,
    test_set, _ = feature_vectors.each_slice(@data.size/3).map{|set|
      Problem.from_array(set.map(&:data), set.map(&:label))
    }

    p "cross_validation_search"
    model, results = Svm.cross_validation_search(training_set, cross_set, COSTS, GAMMAS)

    results.sort_by!{|r| [r[:gamma], r[:cost]] }
    results_matrix = results.map{|e| e[:result].value}.each_slice(COSTS.size).to_a

    if self.panel
      panel.add_plot(xs: COSTS.collect {|n| Math.log2(n)}, 
                     ys: GAMMAS.collect {|n| Math.log2(n)}, 
                     zs: results_matrix,
                     plot_name: "#{classification}, samplesize: #{@samplesize}, dictionary_size: #{@dictionary_size}")
    end
    p "GeometricMean on test_set: #{model.evaluate_dataset(test_set, :evaluator => Evaluator::GeometricMean)}"

    p "Time: #{Time.now - start} seconds"
    timestamp = Time.now.strftime('%Y-%m-%dT%l:%M')
    model.save "tmp/#{timestamp}-#{classification}-model"
    IO.write "tmp/#{timestamp}-#{classification}-dictionary", @selector.global_dictionary
  end
end