class Preprocessor
  attr_accessor :jobs
  def initialize(jobs, *args)
    self.jobs = jobs
  end
end