#
# Runs different SVM training setups
#
# @author Andreas Eger
#
class Runner
  include SvmTrainer
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
    p "selecting feature vectors for #{classification} with #{@selector.class.to_s}" if @verbose
    feature_vectors = @selector.generate_vectors(data,classification,@dictionary_size)

    p @trainer.name if @verbose
    model, results, params = @trainer.search feature_vectors, 30

    predictor = Predictor.new(model: model,
                              classification: classification,
                              preprocessor: @preprocessor,
                              selector: @selector,
                              used_trainer: @trainer.class.to_s,
                              samplesize: @samplesize )

    test_set = fetch_test_set classification
    predictor.overall_accuracy = Evaluator::OverallAccuracy.new(model, @verbose).evaluate_dataset(test_set)
    predictor.geometric_mean = Evaluator::GeometricMean.new(model, @verbose).evaluate_dataset(test_set)
    predictor.save

    p "OverallAccuracy on test_set: #{"%.2f" % (predictor.overall_accuracy*100.0)}%" if @verbose
    p "GeometricMean on test_set: #{predictor.geometric_mean}" if @verbose
    p "cost: #{2**params.cost} gamma:#{2**params.gamma}" if @verbose

    timestamp = predictor.created_at.strftime '%Y-%m-%dT%l:%M'
    IO.write "tmp/#{@trainer.label}_#{classification}_#{timestamp}_results", @trainer.format_results(results)
    predictor
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
            ].flatten#.shuffle
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
    Libsvm::Problem.new.tap{|p| p.set_examples(set.map(&:label), set.map{|e| Libsvm::Node.features(e.data)})}
  end

  private
  def setup args
    folds = args.fetch(:folds) { 3 }
    trainer_defaults = {costs: -5..15, gammas: -15..9, folds: folds}

    if args[:trainer]
      @trainer =  case args[:trainer]
                  when :linear
                    Linear
                  when :doe
                    DoeHeuristic
                  when :grid
                    GridSearch
                  when :nelder_mead
                    NelderMead
                  end.new(trainer_defaults)
    else
      @trainer ||= GridSearch.new(trainer_defaults)
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
    @verbose = args.fetch(:verbose) {false}
  end
end
