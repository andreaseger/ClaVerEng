require_relative 'base'
module Runner
  class Single < Base
    def run(preprocessor, selector, trainer_sym, params={})
      @preprocessor, @selector = get_helpers(preprocessor, selector, params)
      trainer = create_trainer(trainer_sym)
      classification = params.fetch(:classification){ :function }
      samplesize, dic_size = [params.fetch(:max_samplesize){500}, params.fetch(:dictionary_size){500}]

      feature_vectors = get_feature_vectors(classification, samplesize, dic_size).shuffle
      test_set = fetch_test_set classification
      settings = {classification: classification,
                  trainer: trainer.label,
                  selector: @selector.label,
                  preprocessor: @preprocessor.label,
                  dictionary_size: dic_size,
                  samplesize: samplesize}
      l settings

      predictor, results = make_best_predictor( trainer, feature_vectors,
                                                test_set, @preprocessor,
                                                @selector, classification)


      filename = make_filename(settings.merge(predictor_id: predictor.id,
                                              timestamp: Time.now.strftime('%Y%m%d_%H%M')))

      print_and_save_results(predictor, trainer.format_results(results), filename)

      evaluator = SvmTrainer::Evaluator::AllInOne.new(predictor.model)
      evaluator.evaluate_dataset(test_set)
      l "overall_accuracy: #{evaluator.overall_accuracy}"
      l "geometric_mean: #{evaluator.geometric_mean}"
      l "histogram: #{evaluator.full_histogram.sort}"
      p=predictor
      l [p.id, p.classification, p.used_preprocessor, p.used_selector, p.used_trainer, p.dictionary_size, p.samplesize, p.created_at, p.gamma, p.cost].flatten

      predictor
    end

    def get_helpers preprocessor, selector, params
      [create_preprocessor(preprocessor), create_selector(selector, params)]
    end
    def get_feature_vectors(classification, size, dictionary_size)
      jobs = fetch_jobs classification, size
      data = @preprocessor.process jobs, classification
      @selector.generate_vectors(data, classification, dictionary_size)
    end
    def fetch_test_set classification
      create_test_problem(fetch_test_data(classification), @selector, classification)
    end
  end
end
