module Pjpp
  class CareerLevel < ActiveRecord::Base
    self.table_name = 'career_levels'
    has_many :jobs, class_name: 'Pjpp::Job', foreign_key: 'career_level_id'
  end
end
