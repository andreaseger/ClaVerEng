require_relative 'single'
require 'benchmark'
module Runner
  class Train < Single
    def train options
      @preprocessor, @selector = get_helpers(options[:preprocessor],
                                             options[:selector], options)
      classification = options[:classification]

      Benchmark.bm(25) do |x|
        x.report("get_feature_vectors:") {
          @feature_vectors = get_feature_vectors(classification,
                                                  options[:max_samplesize],
                                                  options[:dictionary_size]).shuffle }
        x.report("fetch_test_set:") {
          @test_set = create_test_problem(fetch_test_data(classification),
                                          @selector,
                                          classification) }

        parameter_set = if options[:log2]
                SvmTrainer::ParameterSet.new(options[:gamma], options[:cost])
              else
                SvmTrainer::ParameterSet.make(options[:gamma], options[:cost])
              end
        x.report("train_svm:") { @model = ByParameter.new.train(@feature_vectors,
                                                                parameter_set) }

        p = save_predictor classification

        evaluator = SvmTrainer::Evaluator::AllInOne.new(p.model)
        x.report("evaluate_dataset:") { evaluator.evaluate_dataset(@test_set) }
        l "overall_accuracy: #{evaluator.overall_accuracy}"
        l "geometric_mean: #{evaluator.geometric_mean}"
        l "histogram: #{evaluator.full_histogram.sort}"
        l  [p.id, p.classification, p.used_preprocessor, p.used_selector,
            p.used_trainer, p.dictionary_size, p.samplesize, p.created_at,
            p.gamma, p.cost].flatten
      end
    end
    def save_predictor classification
      p = Predictor.new(selector: @selector,
              preprocessor: @preprocessor,
              model: @model,
              classification: classification,
              used_trainer: ByParameter.to_s,
              samplesize: @feature_vectors.size)
      p.test_model @test_set
      p.save
      p
    end
  end
end