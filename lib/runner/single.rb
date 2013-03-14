require_relative 'base'
module Runner
  class Single < Base
    def run(preprocessor, selector, trainer_sym, params={})
      @classification = params.fetch(:classification){ :function }
      samplesize = params.fetch(:max_samplesize) { 1000 }
      dictionary_size = params.fetch(:dictionary_size) { 600 }

      @preprocessor = create_preprocessor(preprocessor)
      @selector = create_selector(selector, params)

      trainer = create_trainer(trainer_sym)

      feature_vectors = get_feature_vectors(samplesize, dictionary_size)
      test_set = fetch_test_set

      predictor, results = create_predictor( trainer, feature_vectors, test_set)

      IO.write("#{predictor.id}-results", trainer.format_results(results))

      p predictor.serializable_hash
    end
  end
end
