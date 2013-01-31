class Base
  def initialize args={}
    setup(args)
    @verbose = true
  end
  #
  # fetch job data with a 50/50 distribution between correct and false classification
  # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
  # @param  offset [Integer] Offset for the database queries
  #
  # @return [Array<PreprocessedData>]
  def fetch_and_preprocess classification, offset=nil
    jobs = fetch_jobs(classification, @max_samplesize/2, offset)
    @preprocessor.process(jobs, classification)
  end


  #
  # fetch, preprocess a test set, generate feature vectors and create a libsvm Problem
  # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
  #
  # @return [Problem] libsvm Problem
  def fetch_test_set classification
    data = @preprocessor.process(fetch_jobs(classification), classification)
    set = @selector.generate_vectors(data, classification, @dictionary_size)
    Libsvm::Problem.new.tap{|p| p.set_examples(set.map(&:label), set.map{|e| Libsvm::Node.features(e.data)})}
  end

  def fetch_jobs(classification, limit = nil, offset = nil, language = 6)
    faulty = Job.with_language(language).faulty_for_classification(classification)
    faulty = faulty.limit(limit/2) if limit
    faulty = faulty.offset(offset) if offset

    correct =  Job.with_language(language).correct_for_classification(classification).limit(faulty.size)
    correct = correct.offset(offset) if offset
    faulty + correct
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
  def get_preprocessor_klass(p)
    Preprocessor::Simple
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
    case args[:selector]
    when :simple
      Selector::Simple
    when :ngram
      Selector::NGram
    else
      Selector::Simple
    end
  end
  def setup args
  end
end