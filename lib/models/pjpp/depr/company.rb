module Pjpp
  class Company < ActiveRecord::Base
    has_and_belongs_to_many :industries, class_name: 'Pjpp::Industry', join_table: 'companies_industries', foreign_key: 'company_id'
    self.table_name = 'companies'
    belongs_to :parent, class_name: 'Pjpp::Company'
    has_many :jobs, class_name: 'Pjpp::Job', foreign_key: 'company_id'#, conditions: "jobs.deleted is false", include: :status
  end
end
