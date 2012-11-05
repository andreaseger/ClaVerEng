module Pjpp
  class Language < ActiveRecord::Base
    self.table_name = 'languages'
    has_many :jobs, class_name: 'Pjpp::Job', foreign_key: 'language_id'
  end
end
