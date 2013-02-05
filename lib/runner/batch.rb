require_relative 'base'
module Runner
  class Batch < Base
    def initialize(args={})
      super()
      @preprocessor = create_preprocessor(args.fetch(:preprocessor){:simple})

      @selectors = Array(args.fetch(:selectors){ :simple }).map{|s| create_selector(s)}
      @trainers = Array(args.fetch(:trainers){ [:linear, :nelder_mead] })

      @classifications = Array(args.fetch(:classifications){ :function })
      @dictionary_sizes = Array(args.fetch(:dictionary_sizes){ 500 })
      @samplesizes = Array(args.fetch(:samplesizes){ 400 })
    end

    def batch
      result_files = []
      @classifications.each do |classification|
        test_data = fetch_test_data classification
        @samplesizes.each do |samplesize|
          jobs = fetch_jobs classification, samplesize
          data = @preprocessor.process jobs, classification
          @dictionary_sizes.each do |dic_size|
            @selectors.each do |selector|
              selector.reset
              feature_vectors = selector.generate_vectors(data, classification, dic_size)
              test_set = create_test_problem test_data, selector, classification
              @trainers.each do |t|
                trainer = create_trainer t
                settings = {classification: classification,
                                  trainer: trainer.label,
                                  selector: selector.label,
                                  preprocessor: @preprocessor.label,
                                  dictionary_size: dic_size,
                                  samplesize: samplesize}
                l settings
                predictor, results = make_best_predictor( trainer, feature_vectors,
                                                                              test_set, @preprocessor,
                                                                              selector, classification)

                filename = make_filename(settings.merge(predictor_id: predictor.id,
                                                                                timestamp: Time.now.strftime('%Y%m%d_%H%M')))
                result_files << print_and_save_results(predictor, trainer.format_results(results), filename)
              end
            end
          end
        end
      end
      result_files
    end
  end
end