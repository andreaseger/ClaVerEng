module Preprocessor
  class Base
    # def initialize(jobs, args={})
    #   self.jobs = jobs
    # end
    def process
      raise "NotYetImplemented"
    end

    private
    def was_correct? job
      job.qc_job_check.send("wrong_#{@classification}_id").nil?
    end
  end
end