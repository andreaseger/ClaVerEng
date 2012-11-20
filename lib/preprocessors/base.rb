module Preprocessor
  class Base
    # def initialize(jobs, args={})
    #   self.jobs = jobs
    # end
    def process
      raise "NotYetImplemented"
    end

    private
    def get_label job
      job.checked_correct?
    end
  end
end