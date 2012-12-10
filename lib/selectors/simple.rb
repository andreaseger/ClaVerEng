module Selector
  class Simple
    STOPWORD_LOCATION = './lib/stopwords.de'
    DEFAULT_DICTIONARY_SIZE = 5000
    # CLASSIFICATIONS = { function: Pjpp::Function.count,
    #                     industry: Pjpp::Industry.count,
    #                     career_level: Pjpp::CareerLevel.count }
    CLASSIFICATIONS_SIZE = {  function: 19,
                              industry: 632,
                              career_level: 8 }

    attr_accessor :global_dictionary
    attr_accessor :classification

    def initialize args={}
      self.global_dictionary = args.fetch(:global_dictionary) {[]}
    end

    def generate_vectors data_set, classification, dictionary_size=DEFAULT_DICTIONARY_SIZE
      self.classification = classification
      words_per_data = extract_words data_set
      generate_global_dictionary words_per_data, dictionary_size

      words_per_data.map.with_index{|words,index|
        word_set = words.uniq
        make_vector word_set,
                    data_set[index].send("#{classification.to_s}_id"),
                    data_set[index].label
      }
    end

    def generate_vector data, classification, dictionary=self.global_dictionary
      self.classification = classification
      word_set = Set.new extract_words_from_data(data)
      make_vector word_set, data.send("#{classification.to_s}_id"), data.label, dictionary
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
      (data.data.flat_map(&:split) - stopwords).delete_if { |e| e.size <= 3 }
    end

    def reset classification
      self.global_dictionary = []
      self.classification = classification
    end
    private
    def make_vector words, classification_id, label, dictionary=self.global_dictionary
      OpenStruct.new(
        data: dictionary.map{|dic_word|
                words.include?(dic_word) ? 1 : 0
              }.concat(classification_array(classification_id)),
        label: label ? 1 : 0
      )
    end

    def classification_array(id)
      Array.new(CLASSIFICATIONS_SIZE[classification]){|n| n==id ? 1 : 0}
    end
  end
end