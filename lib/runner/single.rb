require_relative 'base'
module Runner
  class Single < Base
    def run(preprocessor, selector, trainer, params={})
      @preprocessor, @selector = get_helpers(preprocessor, selector)
      @trainer = create_trainer(trainer)
      @classification = params.fetch(:classification){ :function }
      l params

      feature_vectors = get_feature_vectors(classification, params.fetch(:max_samplesize){500}, params.fetch(:dictionary_size){500})
      test_set = fetch_test_set classification
      predictor, results = make_best_predictor @trainer, feature_vectors, test_set

      print_and_save_results(predictor, results, classification, @trainer.label)
    end

    def get_helpers preprocessor, selector
      [create_preprocessor(preprocessor), create_selector(selector)]
    end
    def get_feature_vectors(classification, size, dictionary_size)
      jobs = fetch_jobs classification, size
      data = @preprocessor.process jobs, classification
      @selector.generate_vectors(data, classification, dictionary_size)
    end
  end
end