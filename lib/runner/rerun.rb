require_relative 'base'
module Runner
  class Rerun < Base
    attr_accessor :classification
    def run(predictor_file, params={})
      samplesize = params.fetch(:samplesize) { 1000 }

      predictor = SvmPredictor::Model.load_file(predictor_file)

      @classification = predictor.classification
      @preprocessor = predictor.preprocessor
      @selector = predictor.selector

      parameter_set = SvmTrainer::ParameterSet.real(predictor.properties['gamma'], predictor.properties['cost'])

      distribution = params[:distribution]
      if distribution && distribution > 1
        l "create feature_vectors, #{distribution}:1 distribution"
        jobs  = fetch_jobs limit: samplesize
        data = @preprocessor.process jobs
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
        feature_vectors = @selector.generate_vectors(data)
      else
        l 'create feature_vectors, 1:1 distribution'
        feature_vectors = get_feature_vectors(samplesize, predictor.properties['dictionary_size'])
      end
      l 'create test_set'
      test_set = fetch_test_set

      l 'training..evaluation'
      model = SvmTrainer::ByParameter.new.train(feature_vectors, parameter_set)
      predictor_new = SvmPredictor::Model.new(
        selector: @selector,
        preprocessor: @preprocessor,
        svm: model,
        classification: classification,
        trainer_class: 'SvmTrainer::ByParameter',
        properties: { samplesize: feature_vectors.size,
                      distribution: predictor.properties['distribution'],
                      evaluator: predictor.properties['evaluator'],
                      cross_validation: predictor.properties['cross_validation']},
        basedir: SETTINGS['basedir']
      )
      predictor_new.id = params[:id] if params[:id]
      evaluator = Evaluator::AllInOne.new(model)
      evaluator.evaluate_dataset(test_set)
      predictor_new.metrics = evaluator.metrics
      predictor_new.save @pretty

      commit(predictor_new) if params[:git]

      p predictor_new.serializable_hash.slice(:id, :classification, :properties, :metrics, :trainer_class, :preprocessor_class, :selector_class)
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
