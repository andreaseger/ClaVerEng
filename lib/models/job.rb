require_relative 'pjpp/job'
class Job < Pjpp::Job
  scope :checked, -> { joins(:qc_job_check => [:qc_check_status]).
                       where("ja_qc_check_status.check_status IS NOT NULL") }
  scope :checked_correct, -> { joins(:qc_job_check => [:qc_check_status]).
                               where("ja_qc_check_status.check_status = true") }
  scope :checked_faulty, -> { joins(:qc_job_check => [:qc_check_status]).
                              where("ja_qc_check_status.check_status = false") }
  scope :with_language, -> id { where("jobs.language_id = ?", id) }
end