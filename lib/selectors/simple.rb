require_relative 'base'
require 'set'
module Selector
  class Simple < Selector::Base
    STOPWORD_LOCATION = './lib/stopwords.de'
    DEFAULT_DICTIONARY_SIZE = 5000

    attr_accessor :global_dictionary

    def initialize args={}
      self.global_dictionary = args.fetch(:global_dictionary) {[]}
    end

    def generate_vectors data_set
      words_per_data = extract_words data_set
      generate_global_dictionary words_per_data

      words_per_data.each_with_index.map{|words,index|
        word_set = Set.new words
        make_vector word_set, data_set[index].label
      }
    end

    def generate_vector data, dictionary=self.global_dictionary
      word_set = Set.new extract_words_from_data(data)
      make_vector word_set, data.label, dictionary
    end

    def stopwords(location=STOPWORD_LOCATION)
      @stopwords ||= IO.read(location).split
    end

    def generate_global_dictionary all_words, size=DEFAULT_DICTIONARY_SIZE
      return unless global_dictionary.empty?

      words = all_words.flatten.group_by{|e| e}.values
               .sort_by{|e| e.size}
               .map{|e| [e[0],e.size]}
      self.global_dictionary = words.last(size).map(&:first).reverse
    end

    def extract_words data_set
      data_set.map do |data|
        extract_words_from_data data
      end
    end

    def extract_words_from_data data
      (data.data.map(&:split).flatten - stopwords).delete_if { |e| e.size <= 3 }
    end

    private
    def make_vector words, label, dictionary=self.global_dictionary
      OpenStruct.new(
        data: dictionary.map{|dic_word|
                words.include?(dic_word) ? 1 : 0
              },
        label: label ? 1 : 0
      )
    end
  end
end