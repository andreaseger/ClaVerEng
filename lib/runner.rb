require_relative 'preprocessors/simple'
require_relative 'selectors/simple'
require_relative 'trainer/doe_heuristic'
require_relative 'trainer/grid_search'
require 'benchmark'

class Runner
  attr_accessor :preprocessor
  attr_accessor :selector
  attr_accessor :trainer
  # attr_accessor :panel

  # COSTS = [-5, -3, -1, 0, 1, 3, 5, 8, 10, 13, 15].collect {|n| 2**n}
  # GAMMAS = [-15, -12, -8, -5, -3, -1, 1, 3, 5, 7, 9].collect {|n| 2**n}

  def initialize args={}
    folds = args.fetch(:folds) { 3 }
    @trainer =  case args[:trainer]
                when :doe
                  Trainer::DoeHeuristic
                else
                  Trainer::GridSearch
                end.new(costs: -5..15, gammas: -15..9, folds: folds)

    @preprocessor = case args[:preprocessor]
                    when :simple
                      Preprocessor::Simple
                    else
                      Preprocessor::Simple
                    end.new
    @selector = case args[:selector]
                when :simple
                  Selector::Simple
                else
                  Selector::Simple
                end.new
  end

  def run args={}
    @samplesize = args.fetch(:samplesize,5000)
    @dictionary_size = args.fetch(:dictionary_size,5000)
    classification = args.fetch(:classification, :function)

    benchmark={}
    if classification == :all
      [:function, :industry, :career_level].each do |e|
        benchmark[e] = Benchmark.measure {
          data = fetch_and_preprocess e
          run_for_classification(data, e)
        }
      end
    else
      benchmark[classification] = Benchmark.measure {
        data = fetch_and_preprocess classification
        run_for_classification(data, classification)
      }
    end

    puts
    benchmark.each do |k,v|
      print "#{k}: "
      puts v
    end
  end

  def fetch_and_preprocess classification
    jobs = [  Job.with_language(5).correct_for_classification(classification).limit(@samplesize/2),
              Job.with_language(5).faulty_for_classification(classification).limit(@samplesize/2)  ].flatten.shuffle
    @preprocessor.process(jobs, classification)
  end

  def run_for_classification data, classification
    p "selecting feature vectors for #{classification} with #{@selector.class.to_s}"
    feature_vectors = @selector.generate_vectors(data,classification,@dictionary_size)

    # training_set,
    # cross_set,
    # test_set, _ = feature_vectors.each_slice(data.size/3).map{|set|
    #   Problem.from_array(set.map(&:data), set.map(&:label))
    # }

    p @trainer.name
    model, results = @trainer.search feature_vectors, 6

    #p "GeometricMean on test_set: #{model.evaluate_dataset(test_set, :evaluator => Evaluator::GeometricMean)}"

    best = results.invert[results.values.max]

    p "best accuracy: cost: #{best[:cost]} gamma:#{best[:gamma]} => results: #{results.values.max}"
    timestamp = Time.now.strftime('%Y%m%d_%H%M')
    model.save "tmp/#{timestamp}_#{classification}_model"
    IO.write "tmp/#{timestamp}_#{classification}_dictionary", @selector.global_dictionary
    IO.write "tmp/#{timestamp}_#{classification}_results", format_results(results)
  end
  private
  def format_results results
    results.map{ |k,v| [Math.log2(k[:gamma]), "#{Math.log2(k[:cost])} #{Math.log2(k[:gamma])} #{v}"] }
           .group_by{|e| e[0]}.values.map{|e| e.map{|f| f[1]}.join("\n")}.join "\n\n"
  end
end
