require_relative 'base'
module Runner
  class Single < Base
    def run(preprocessor, selector, trainer_sym, params={})
      @classification = params.fetch(:classification){ :function }
      samplesize = params.fetch(:samplesize) { 1000 }
      dictionary_size = params.fetch(:dictionary_size) { 600 }

      @preprocessor = create_preprocessor(preprocessor)
      @selector = create_selector(selector, params)

      trainer = create_trainer(trainer_sym)

      l 'create feature_vectors'
      feature_vectors = get_feature_vectors(samplesize, dictionary_size)
      l 'create test_set'
      test_set = fetch_test_set

      l 'parameter search..training..evaluation'
      predictor, results = create_predictor( trainer, feature_vectors, test_set)

      IO.write(File.join(SETTINGS['basedir'], "#{predictor.id}-results"), trainer.format_results(results))

      commit(predictor) if params[:git]

      p predictor.serializable_hash.slice(:id, :classification, :properties, :metrics, :trainer_class, :preprocessor_class, :selector_class)
    end
    def commit predictor
      puts system(<<-GIT.gsub(/^ {8}/,''))
        cd #{SETTINGS['basedir']}
        git add .
        git commit -m "##{predictor.id} #{predictor.classification} #{predictor.trainer_class}

        #{predictor.properties}
        #{predictor.metrics.except(:correct_histogram, :faulty_histogram, :full_histogram)}"
      GIT
    end
  end
end
