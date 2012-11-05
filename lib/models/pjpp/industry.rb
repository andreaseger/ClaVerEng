module Pjpp
  class Industry < ActiveRecord::Base
    self.table_name = 'industries'
    has_many :jobs, class_name: 'Pjpp::Job', foreign_key: 'industry_id'
    has_and_belongs_to_many :companies, class_name: 'Pjpp::Company', join_table: 'companies_industries', foreign_key: 'indutry_id'
  end
end
