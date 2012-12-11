#TODO make this require stuff nicer and more dynamic maybe with some load/autoload stuff
require_relative 'preprocessors/simple'
require_relative 'selectors/simple'
require_relative 'selectors/n_gram'
require_relative 'trainer/doe_heuristic'
require_relative 'trainer/grid_search'
require_relative 'models/predictor'

class Runner
  attr_accessor :preprocessor
  attr_accessor :selector
  attr_accessor :trainer

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
                when :ngram
                  Selector::NGram
                else
                  Selector::Simple
                end.new
  end

  def run args={}
    @samplesize = args.fetch(:samplesize,5000)
    @dictionary_size = args.fetch(:dictionary_size,5000)
    classification = args.fetch(:classification, :function)

    if classification == :all
      [:function, :industry, :career_level].each do |c|
        @selector.reset c
        data = fetch_and_preprocess c
        run_for_classification(data, c)
      end
    else
      data = fetch_and_preprocess classification
      run_for_classification(data, classification)
    end
  end

  def fetch_and_preprocess classification, offset=0
    jobs =  [ Job.with_language(5).
                  correct_for_classification(classification).
                  limit(@samplesize/2).
                  offset(offset),
              Job.with_language(5).
                  faulty_for_classification(classification).
                  limit(@samplesize/2)
                  .offset(offset)
            ].flatten.shuffle
    @preprocessor.process(jobs, classification)
  end

  def fetch_test_set classification
    data = fetch_and_preprocess(classification, @samplesize*3)
    set = @selector.generate_vectors(data, classification, @dictionary_size)
    Problem.from_array(set.map(&:data), set.map(&:label))
  end
  def run_for_classification data, classification
    p "selecting feature vectors for #{classification} with #{@selector.class.to_s}"
    feature_vectors = @selector.generate_vectors(data,classification,@dictionary_size)

    p @trainer.name
    model, results = @trainer.search feature_vectors, 6
    test_set = fetch_test_set classification

    predictor = Predictor.new(model: model,
                              classification: classification,
                              used_preprocessor: @preprocessor.class.to_s,
                              used_selector: @selector.class.to_s,
                              used_trainer: @trainer.class.to_s,
                              dictionary: @selector.global_dictionary,
                              selector_properties: {gram_size: 6},
                              samplesize: @samplesize,
                              dictionary_size: @dictionary_size )
    predictor.overall_accuracy = model.evaluate_dataset(test_set, evaluator: Evaluator::OverallAccuracy).value
    predictor.geometric_mean = model.evaluate_dataset(test_set, evaluator: Evaluator::GeometricMean).value
    predictor.save

    p "OverallAccuracy on test_set: #{predictor.overall_accuracy}"
    p "GeometricMean on test_set: #{predictor.geometric_mean}"
    p "cost: #{model.cost} gamma:#{model.gamma}"

    IO.write "tmp/#{@trainer.label}_#{classification}_#{timestamp}_results", @trainer.format_results(results)
  end
end