%w(career_level function industry language qa_job_check).each {|model| require_relative model }
module Pjpp
  class Job < ActiveRecord::Base
    self.table_name = 'jobs'
    # only need those to get the labels of them otherwise the ids are enough
    belongs_to :career_level, class_name: 'Pjpp::CareerLevel'
    belongs_to :function, class_name: 'Pjpp::Function'
    belongs_to :industry, class_name: 'Pjpp::Industry'

    # need these to filter the jobs
    has_one :qc_job_check, class_name: 'Pjpp::QcJobCheck', foreign_key: 'job_id'
    # belongs_to :company, class_name: 'Pjpp::Company'
    belongs_to :language, class_name: 'Pjpp::Language'
    # belongs_to :status, class_name: 'Pjpp::JobStatus', foreign_key: 'job_status_id', :extend => Pjpp::JobStatus::JobExtension

=begin
    belongs_to :country_version
    # non default table names for these relations
    belongs_to :salary_range, class_name: 'Pjpp::JobSalaryRange', foreign_key: 'job_salary_range_id'
    has_many :required_languages, :class_name => 'Pjpp::JobLanguage', :dependent => :delete_all
    has_and_belongs_to_many :graduations
    has_and_belongs_to_many :education_fields
=end
   end
end
