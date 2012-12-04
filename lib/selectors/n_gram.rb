require_relative 'simple'
module Selector
  class NGram < Selector::Simple
    def initialize args={}
      super
      @gram_size = args.fetch(:gram_size) { 2 }
    end

    def extract_words_from_data data
      (data.data.flat_map(&:split) - stopwords)
                .delete_if { |e| e.size <= 3 }
                .each_cons(@gram_size).map{|e| e.join " " }
    end
  end
end