module Selector
  class Base
    attr_accessor :data
    def initialize(data, *args)
      self.data = data
    end
  end
end