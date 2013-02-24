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

  CLASSIFICATION_IDS ={ function: Pjpp::Function.pluck(:id),
                                        career_level: Pjpp::CareerLevel.pluck(:id),
                                        industry: Pjpp::Industry.pluck(:id) }

  def act_as_false?
    @act_as_false
  end
  def act_as_false!
    @act_as_false = true
  end
  def classification_id(classification)
    if @act_as_false
      CLASSIFICATION_IDS[classification.to_sym].reject{|e| e == self.send("#{classification}_id")}.sample
    else
      self.send("#{classification}_id")
    end
  end
  def label(classification)
    if @act_as_false || (qc = self.qc_job_check).nil?
      false
    else
      qc.send("wrong_#{classification}_id").nil?
    end
  end
end