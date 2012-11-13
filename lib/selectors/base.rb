module Selector
  class Base
    attr_accessor :data
    # def initialize(data, args={})
    #   self.data = data
    # end
    def select_feature_vector
      raise "NotYetImplemented"
    end
  end
end