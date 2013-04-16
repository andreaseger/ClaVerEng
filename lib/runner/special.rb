require_relative 'base'
module Runner
  class Special < Base
    attr_accessor :classification
    def run(preprocessor, selector, params={})
      @classification = params.fetch(:classification){ :function }
      samplesize = params.fetch(:samplesize) { 1000 }
      dictionary_size = params.fetch(:dictionary_size) { 600 }

      @preprocessor = create_preprocessor(preprocessor)

      l 'create feature_vectors, 1:1 distribution'
      jobs = fetch_jobs limit: samplesize, original_ids: false
      data = @preprocessor.process jobs
      %w(simple bns ig).each do |s|
        GC.start
        selector = create_selector(s.to_sym, params)
        selector.build_dictionary data
        [800,600,400].each do |d|
          selector.global_dictionary = selector.global_dictionary.first(d)
          IO.write(File.join('tmp',"#{s}_#{d}_dictionary"), selector.global_dictionary.join("\n"))
          feature_vectors = selector.generate_vectors(data, dictionary_size)
          f = feature_vectors.map(&:word_data)
          p "mean true features #{s} #{d}: #{f.map{|e| e.reduce(&:+)}.reduce(&:+)/6000}"
          m = f.transpose.map{|e| e.reduce(&:+)}
          IO.write(File.join('tmp',"#{s}_#{d}_feature_statistics.json"),m.to_json)
        end
      end

      #l 'parameter search..training..evaluation'
      #%w(grid doe nelder_mead).each do |trainer_class|
      #  l trainer_class
      #  trainer = create_trainer(trainer_class.to_sym, params )
      #  _,results,_ = trainer.search feature_vectors, (trainer.is_a?(NelderMead) ? 20 : 5 )
      #  IO.write(File.join('tmp', "#{trainer_class}_results"), trainer.format_results(results))
      #end
    end
  end
end
