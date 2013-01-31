class Batch < Base

  def batch

    data = 
    classifications.each do |classification|
      test_set = fetch_test_set classification
      dic_sizes.each do |dic_size|
        feature_vectors = @selector.generate_vectors(data, classification, dic_size)
        @trainers.each do |trainer|
          predictor = find_best_predictor(trainer, feature_vectors)
          predictor.test_model test_set
          predictor.save
        end
      end
    end
  end

  def find_best_predictor(trainer, feature_vectors)
    model, results, params = trainer.search feature_vectors
    Predictor.new(selector: @selector, preprocessor: @preprocessor,model: model, used_trainer: trainer.class.to_s, samplesize: feature_vectors.size)
  end

  def run(preprocessor, selector, size)
    feature_vectors = get_feature_vectors(preprocessor, selector, classification, size)
    @trainers.each do |trainer|
    end
  end

  def get_feature_vectors(preprocessor, selector, classification, size, dictionary_size)
    jobs = fetch_jobs classification, size
    data = preprocessor.process jobs, classification
    selector.generate_vectors(data, classification, dictionary_size)
  end

  def get_helper(preprocessor, selector)
    [create_preprocessor(preprocessor),
    create_selector(selector)]
  end
  def setup args
    @trainers = args.fetch(:trainers){ [:linear, :nelder_mead] }.map { |t| create_trainer(t) }
    @preprocessor = create_preprocessor(args[:preprocessor])
    @selector = create_selector(args[:selector])
  end
end