require_relative 'base'
module Runner
  class Special < Base
    attr_accessor :classification
    def run(preprocessor, selector, params={})
      @classification = params.fetch(:classification){ :function }
      samplesize = params.fetch(:samplesize) { 1000 }
      dictionary_size = params.fetch(:dictionary_size) { 600 }

      @preprocessor = create_preprocessor(preprocessor)
      @selector = create_selector(selector, params)

      l 'create feature_vectors, 1:1 distribution'
      feature_vectors = get_feature_vectors(samplesize, dictionary_size)

      l 'parameter search..training..evaluation'
      %w(grid doe nelder_mead).each do |trainer_class|
        l trainer_class
        trainer = create_trainer(trainer_class.to_sym, params )
        _,results,_ = trainer.search feature_vectors, (trainer.is_a?(NelderMead) ? 20 : 5 )
        IO.write(File.join('tmp', "#{trainer_class}_results"), trainer.format_results(results))
      end
    end
  end
end
