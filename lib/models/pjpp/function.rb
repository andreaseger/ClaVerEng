module Pjpp
  class Function < ActiveRecord::Base
    self.table_name = 'functions'
    has_many :jobs, class_name: 'Pjpp::Job', foreign_key: 'function_id'
  end
end
