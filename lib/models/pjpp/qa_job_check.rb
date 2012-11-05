require_relative 'qa_check_status'
module Pjpp
  class QcJobCheck < ActiveRecord::Base
    self.table_name = 'ja_qc_job_checks'
    has_one :qc_check_status, class_name: 'Pjpp::QcCheckStatus'
    belongs_to :job, class_name: 'Pjpp::Job'

    def self.get_for_job(job_id)
      Pjpp::QcJobCheck.find_by_job_id(job_id)
    end
  end
end
