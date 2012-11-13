require_relative 'base'
require 'set'
module Selector
  class Simple < Selector::Base
    STOPWORD_LOCATION = './lib/stopwords.de'
    attr_accessor :global_dictionary

    def initialize args={}
      self.global_dictionary = args.fetch(:global_dictionary) {[]}
    end
    def select_feature_vector data
      words_per_vector = extract_words data
      generate_global_dictionary words_per_vector
      words_per_vector.each_with_index.map{|words,index|
        word_set = Set.new words
        OpenStruct.new(
          data: global_dictionary.map{|word|
                  word_set.include?(word) ? 1 : 0
                },
          checked_correct: data[index].checked_correct ? 1 : 0
        )
      }
    end

    def stopwords
      @stopwords ||= IO.read(STOPWORD_LOCATION).split
    end

    def generate_global_dictionary all_words
      return unless global_dictionary.empty?

      words = all_words.flatten.group_by{|e| e}.values
               .sort_by{|e| e.size}
               .map{|e| [e[0],e.size]}
      p "#{words.size} uniq words found, selecting the most frequent 5000"
      self.global_dictionary = words.last(5000).map(&:first).reverse
    end
    def extract_words data
      data.map do |e|
        ([ e.title.split, e.description.split ].flatten - stopwords).delete_if { |e| e.size <= 3 }
      end
    end
  end
end