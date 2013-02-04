require_relative 'base'
module Runner
  class Batch < Base
    def initialize(args={})
      super()
      @preprocessor = create_preprocessor(args.fetch(:preprocessor){:simple})

      @selectors = Array(args.fetch(:selectors){ :simple }).map{|s| create_selector(s)}
      @trainers = Array(args.fetch(:trainers){ [:linear, :nelder_mead] }).map { |t| create_trainer(t) }

      @classifications = Array(args.fetch(:classifications){ :function })
      @dictionary_sizes = Array(args.fetch(:dictionary_sizes){ 500 })
      @samplesize = args.fetch(:samplesize){400}
    end

    def batch
      @classifications.each do |classification|
        test_data = fetch_test_set classification

        jobs = fetch_jobs classification, @samplesize
        data = @preprocessor.process jobs, classification
        @dictionary_sizes.each do |dic_size|
          @selectors.each do |selector|
            feature_vectors = selector.generate_vectors(data, classification, dic_size)
            test_set = create_test_problem test_data, selector, classification
            @trainers.each do |trainer|
              predictor, results = make_best_predictor(trainer, feature_vectors, test_set, @preprocessor, selector, classification)
              print_and_save_results(predictor, results, classification, trainer.label)
            end
            selector.reset
          end
        end
      end
    end
  end
end