require_relative '../interfaces'
module Preprocessor
  #
  # Preprocessor Base Class
  #
  # @author Andreas Eger
  #
  class Base
    #
    # checks if the job was classified correctly
    # @param job [Job]
    #
    # @return [Boolean]
    def correct? job
      job.qc_job_check.send("wrong_#{@classification}_id").nil?
    end
  end
end