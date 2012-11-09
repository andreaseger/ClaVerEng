module Preprocessor
  class Base
    attr_accessor :jobs
    # def initialize(jobs, *args)
    #   self.jobs = jobs
    # end
    def process
      raise "NotYetImplemented"
    end
  end
end