module Selector
  class Base
    # CLASSIFICATIONS = { function: Pjpp::Function.count,
    #                     industry: Pjpp::Industry.count,
    #                     career_level: Pjpp::CareerLevel.count }
    CLASSIFICATIONS_SIZE = {  function: 19,
                              industry: 632,
                              career_level: 8 }
    def select_feature_vector
      raise "NotYetImplemented"
    end

    private
    def classification_array(id)
      Array.new(CLASSIFICATIONS_SIZE[classification]){|n| n==id ? 1 : 0}
    end
  end
end