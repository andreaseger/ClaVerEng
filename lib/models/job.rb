require_relative 'pjpp/job'
#
# Wrapper Class for Pjpp:Job
#
# @author Andreas Eger
#
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

  scope :correct_for_classification,
    -> classification { joins(:qc_job_check).
                        where("ja_qc_job_checks.wrong_#{classification}_id IS NULL").
                        includes(:qc_job_check)}
  scope :faulty_for_classification,
    -> classification { joins(:qc_job_check).
                        where("ja_qc_job_checks.wrong_#{classification}_id IS NOT NULL").
                        includes(:qc_job_check)}

  # @!method original_industry_id
  # @!method original_function_id
  # @!method original_career_level_id
  %w(industry function career_level).each do |method|
    define_method "original_#{method}_id" do
       self.qc_job_check.try(:send, "wrong_#{method}_id") || self.send("#{method}_id")
    end
  end

  def checked_correct?
    self.qc_job_check.qc_check_status.check_status
  end
end