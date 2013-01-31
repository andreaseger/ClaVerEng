class Base
  #
  # fetch job data with a 50/50 distribution between correct and false classification
  # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
  # @param  offset [Integer] Offset for the database queries
  #
  # @return [Array<PreprocessedData>]
  def fetch_and_preprocess classification, offset=nil
    jobs = fetch_jobs(classification, 6, @max_samplesize/2, offset)
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

  def fetch_jobs(classification, language = 6, limit = nil, offset = nil)
    faulty = Job.with_language(language).faulty_for_classification(classification)
    faulty = faulty.limit(limit) if limit
    faulty = faulty.offset(offset) if offset

    correct =  Job.with_language(language).correct_for_classification(classification).limit(faulty.size)
    correct = correct.offset(offset) if offset
    faulty + correct
  end

end