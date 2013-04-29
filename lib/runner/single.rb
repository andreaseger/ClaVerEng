require_relative 'base'
module Runner
  class Single < Base
    attr_accessor :classification
    def run(preprocessor, selector, trainer_sym, params={})
      @classification = params.fetch(:classification){ :function }
      samplesize = params.fetch(:samplesize) { 1000 }
      dictionary_size = params.fetch(:dictionary_size) { 600 }

      @language = params.fetch(:language){'en'}
      @preprocessor = create_preprocessor(preprocessor, language: @language)
      @selector = create_selector(selector, params)

      trainer = create_trainer(trainer_sym, params )

      distribution = params[:distribution]
      if distribution && distribution > 1
        l "create feature_vectors, #{distribution}:1 distribution"
        jobs  = fetch_jobs limit: samplesize
        data = @preprocessor.process jobs
        @selector.build_dictionary data
        data = data.flat_map do |d|
          if d.label
            d
          else
            ids = CLASSIFICATION_IDS[@classification.to_sym].reject{|e| e == d.id }.sample(distribution)
            ids.map do |id|
              d.tap{|e| e.id=id }
            end
          end
        end
        feature_vectors = @selector.generate_vectors(data, dictionary_size)
      else
        l 'create feature_vectors, 1:1 distribution'
        feature_vectors = get_feature_vectors(samplesize, dictionary_size)
      end
      l 'create test_set'
      test_set = fetch_test_set
      binding.pry

      l 'parameter search..training..evaluation'
      predictor, results = create_predictor(trainer,
                                            feature_vectors,
                                            test_set,
                                            id: params[:id],
                                            distribution: distribution)

      IO.write( File.join(SETTINGS['basedir'], predictor.results_filename),
                trainer.format_results(results))

      commit(predictor) if params[:git]

      p predictor.serializable_hash.slice(:id,
                                          :classification,
                                          :properties,
                                          :metrics,
                                          :trainer_class,
                                          :preprocessor_class,
                                          :selector_class)
    end
    def commit predictor
      puts system(<<-GIT.gsub(/^ {8}/,''))
        cd #{SETTINGS['basedir']}
        git add .
        git commit -m "#{predictor.id} #{predictor.classification} #{predictor.trainer_class}

        #{predictor.properties}
        #{predictor.metrics.except(:correct_histogram, :faulty_histogram, :full_histogram)}"
      GIT
    end
  end
end
