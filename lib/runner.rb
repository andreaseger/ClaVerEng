#TODO make this require stuff nicer and more dynamic maybe with some load/autoload stuff
require_relative 'preprocessors/simple'
require_relative 'selectors/simple'
require_relative 'selectors/n_gram'
require_relative 'trainer/doe_heuristic'
require_relative 'trainer/grid_search'

#
# Runs different SVM training setups
#
# @author Andreas Eger
#
class Runner
  attr_accessor :preprocessor
  attr_accessor :selector
  attr_accessor :trainer

  def initialize args={}
    setup(args)
  end

  def run args={}
    setup(args)
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


  #
  # create a predictor for a given classification
  # @param  data [Array<PreprocessedData>] list of preprocessed data
  # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
  #
  # @return
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

    timestamp = predictor.created_at.strftime '%Y-%m-%dT%l:%M'
    IO.write "tmp/#{@trainer.label}_#{classification}_#{timestamp}_results", @trainer.format_results(results)
  end


  #
  # fetch job data with a 50/50 distribution between correct and false classification
  # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
  # @param  offset [Integer] Offset for the database queries
  #
  # @return [Array<PreprocessedData>]
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


  #
  # fetch, preprocess a test set, generate feature vectors and create a libsvm Problem
  # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
  #
  # @return [Problem] libsvm Problem
  def fetch_test_set classification
    data = fetch_and_preprocess(classification, @samplesize*3)
    set = @selector.generate_vectors(data, classification, @dictionary_size)
    Problem.from_array(set.map(&:data), set.map(&:label))
  end

  private
  def setup args
    folds = args.fetch(:folds) { 3 }
    trainer_defaults = {costs: -5..15, gammas: -15..9, folds: folds}

    if args[:trainer]
      @trainer =  case args[:trainer]
                  when :doe
                    Trainer::DoeHeuristic
                  when :grid
                    Trainer::GridSearch
                  end.new(trainer_defaults)
    else
      @trainer ||= Trainer::GridSearch.new(trainer_defaults)
    end

    if args[:preprocessor]
      @preprocessor = case args[:preprocessor]
                      when :simple
                        Preprocessor::Simple
                      end.new
    else
      @preprocessor ||= Preprocessor::Simple.new
    end

    if args[:selector]
      @selector = case args[:selector]
                  when :simple
                    Selector::Simple
                  when :ngram
                    Selector::NGram
                  end.new
    else
      @selector ||= Selector::Simple.new
    end

    @samplesize = args.fetch(:samplesize){ @samplesize || 5000 }
    @dictionary_size = args.fetch(:dictionary_size) { @dictionary_size || 5000 }
  end
end