require_relative 'base'
#
# Runs different SVM training setups
#
# @author Andreas Eger
#
class Individual < Base
  include SvmTrainer
  attr_accessor :preprocessor
  attr_accessor :selector
  attr_accessor :trainer

  def run args={}
    setup(args)
    classification = args.fetch(:classification, :function)

    if classification == :all
      [:function, :industry, :career_level].each do |c|
        @selector.reset c
        data = fetch_and_preprocess c
        predictor = run_for_classification(data, c)
        puts predictor.id if @verbose
      end
    else
      data = fetch_and_preprocess classification
      predictor = run_for_classification(data, classification)
      puts predictor.id if @verbose
    end
  end


  #
  # create a predictor for a given classification
  # @param  data [Array<PreprocessedData>] list of preprocessed data
  # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
  #
  # @return
  def run_for_classification data, classification
    puts "using #{data.size} jobs for classification: #{classification}" if @verbose
    puts "selecting feature vectors for #{classification} with #{@selector.class.to_s}" if @verbose
    feature_vectors = @selector.generate_vectors(data,classification,@dictionary_size)

    puts @trainer.name if @verbose
    model, results, params = @trainer.search feature_vectors.shuffle, 30

    predictor = Predictor.new(model: model,
                              classification: classification,
                              preprocessor: @preprocessor,
                              selector: @selector,
                              used_trainer: @trainer.class.to_s,
                              samplesize: data.size )

    test_set = fetch_test_set classification
    predictor.overall_accuracy = Evaluator::OverallAccuracy.new(model, @verbose).evaluate_dataset(test_set)
    predictor.geometric_mean = Evaluator::GeometricMean.new(model, @verbose).evaluate_dataset(test_set)
    predictor.save

    puts "OverallAccuracy on test_set: #{"%.2f" % (predictor.overall_accuracy*100.0)}%" if @verbose
    puts "GeometricMean on test_set: #{predictor.geometric_mean}" if @verbose
    puts "cost: #{2**params.cost} gamma:#{2**params.gamma}" if @verbose

    timestamp = predictor.created_at.strftime '%Y-%m-%dT%l:%M'
    IO.write "tmp/#{@trainer.label}_#{classification}_#{timestamp}_results", @trainer.format_results(results)
    predictor
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

    @max_samplesize = args.fetch(:max_samplesize){ @max_samplesize || 1000 }
    @dictionary_size = args.fetch(:dictionary_size) { @dictionary_size || 1000 }
    @verbose = args.fetch(:verbose) {@verbose || false}
  end
end
