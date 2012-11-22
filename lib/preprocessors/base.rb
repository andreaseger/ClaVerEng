module Preprocessor
  class Base
    def correct? job
      job.qc_job_check.send("wrong_#{@classification}_id").nil?
    end
  end
end