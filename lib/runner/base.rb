module Runner
  class Base
    include SvmTrainer

    def initialize(args={})
      @verbose = args.fetch(:verbose){true}
    end

    def l msg
      puts msg if @verbose
    end

    #
    # parameter search and creation of a predictor including the evaluation results
    # @param  trainer [SvmTrainer] SvmTrainer which searches for the best parameters
    # @param  feature_vectors [Array<FeatureVector>] FeatureVectors to use for the parameter search and training
    # @param  test_set [Libsvm::Problem] will be used to make the final evaluation of tha SVM model
    #
    # @return [Predictor]
    def make_best_predictor(trainer, feature_vectors, test_set, preprocessor=@preprocessor, selector=@selector, classification=@classification)
      model, results, _ = trainer.search feature_vectors, 15
      predictor = Predictor.new(selector: selector,
        preprocessor: preprocessor,
        model: model,
        classification: classification,
        used_trainer: trainer.class.to_s,
        samplesize: feature_vectors.size)
      predictor.test_model test_set, @verbose
      predictor.save
      [predictor, results]
    end

    def make_filename(settings)
      [ settings[:predictor_id],
        settings[:trainer],
        settings[:classification],
        settings[:selector],
        settings[:preprocessor],
        settings[:dictionary_size],
        settings[:samplesize],
        settings[:timestamp]
      ].join '_'
    end

    def print_and_save_results predictor, results, filename
      l "OverallAccuracy on test_set: #{"%.2f" % (predictor.overall_accuracy*100.0)}%"
      l "GeometricMean on test_set: #{predictor.geometric_mean}"
      l "cost: #{predictor.cost} gamma:#{predictor.gamma}"
      l "cost: #{Math.log2(predictor.cost)} gamma:#{Math.log2(predictor.gamma)} || log2"

      IO.write "results/#{filename}", results
      filename
    end

    #
    # fetch, preprocess a test set, generate feature vectors and create a libsvm Problem
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    #
    # @return [Problem] libsvm Problem
    def fetch_test_data classification
      data = @preprocessor.process(fetch_jobs(classification, 5000, 10000), classification)
    end
    def create_test_problem data, selector, classification
      set = selector.generate_vectors(data, classification, @dictionary_size)
      Libsvm::Problem.new.tap{|p| p.set_examples(set.map(&:label), set.map{|e| Libsvm::Node.features(e.data)})}
    end


    #
    # fetch job data with a 50/50 distribution between correct and false classification
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @param  limit [Integer] how much jobs to get
    # @param  offset [Integer] offset the results
    # @param  language [Integer] language_id, see pjpp
    #
    # @return [Array<Job>]
    def fetch_jobs(classification, limit = 100, offset = 0, language = 6)
      correct = Job.with_language(language).correct_for_classification(classification)
      correct = correct.limit(limit/2) if limit
      correct = correct.offset(offset) if offset > 0

      faulty = Job.with_language(language).correct_for_classification(classification)
      faulty = faulty.limit(limit/2) if limit
      faulty = faulty.offset(offset + limit/2)
      faulty = faulty.map { |e| e.act_as_false!; e }

      correct + faulty
    end


    def create_trainer(trainer, params={})
      get_trainer_klass(trainer).new(params)
    end
    #
    # fetch SvmTrainer class from :symbol
    # @param  trainer [Symbol]
    #
    # @return [SvmTrainer]
    def get_trainer_klass(trainer)
      case trainer
      when :linear
        Linear
      when :doe
        DoeHeuristic
      when :grid
        GridSearch
      when :nelder_mead
        NelderMead
      else
        GridSearch
      end
    end

    def create_preprocessor(preprocessor, params={})
      get_preprocessor_klass(preprocessor).new(params)
    end
    #
    # fetch preprocessor class, only one kind implemented so will always return Preprocessor::Simple
    # @param  p [Symbol]
    #
    # @return [Preprocessor]
    def get_preprocessor_klass(preprocessor)
      case preprocessor
      when :simple
        Preprocessor::Simple
      when :industry_map
        Preprocessor::WithIndustryMap
      else
        Preprocessor::WithIndustryMap
      end
    end

    def create_selector(selector, params={})
      get_selector_klass(selector).new(params)
    end
    #
    # fetch Selector class from :symbol
    # @param  selector [Symbol]
    #
    # @return [Selector]
    def get_selector_klass(selector)
      case selector
      when :simple
        Selector::Simple
      when :ngram
        Selector::NGram
      when :binary_encoded
        Selector::WithBinaryEncoding
      else
        Selector::Simple
      end
    end
  end
end
