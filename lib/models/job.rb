require_relative 'pjpp/job'
class Job < Pjpp::Job
  scope :checked, -> { joins(:qc_job_check => [:qc_check_status]).
                       where("ja_qc_check_status.check_status IS NOT NULL").
                       includes(:qc_job_check => [:qc_check_status]) }
  scope :checked_correct, -> { joins(:qc_job_check => [:qc_check_status]).
                               where("ja_qc_check_status.check_status = true").
                               includes(:qc_job_check => [:qc_check_status]) }
  scope :checked_faulty, -> { joins(:qc_job_check => [:qc_check_status]).
                              where("ja_qc_check_status.check_status = false").
                              includes(:qc_job_check => [:qc_check_status]) }
  scope :with_language, -> id { where("jobs.language_id = ?", id) }



  def checked_correct?
    self.qc_job_check.qc_check_status.check_status
  end
end