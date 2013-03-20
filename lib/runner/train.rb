require_relative 'single'
module Runner
  class Train < Single
    def train options
      @classification = options.fetch(:classification){ :function }

      @preprocessor = create_preprocessor(preprocessor)
      @selector = create_selector(selector, options)

      @feature_vectors = get_feature_vectors( options[:max_samplesize],
                                              options[:dictionary_size])
      @test_set = create_test_problem(fetch_test_data)

      parameter_set = if options[:log2]
              SvmTrainer::ParameterSet.new(options[:gamma], options[:cost])
            else
              SvmTrainer::ParameterSet.real(options[:gamma], options[:cost])
            end
      @model = ByParameter.new.train(@feature_vectors, parameter_set)

      p = save_predictor

      commit(predictor) if params[:git]

      p predictor.serializable_hash.slice(:id, :classification, :properties, :metrics, :trainer_class, :preprocessor_class, :selector_class)
    end
    def save_predictor
      p = Predictor.new(selector: @selector,
              preprocessor: @preprocessor,
              svm: @model,
              classification: @classification,
              trainer_class: ByParameter.to_s,
              properties: { samplesize: feature_vectors.size },
              basedir: SETTINGS['basedir']
      evaluator = Evaluator::AllInOne.new(@model)
      evaluator.evaluate_dataset(@test_set)
      p.metrics = evaluator.metrics
      p.save
      p
    end
  end
end