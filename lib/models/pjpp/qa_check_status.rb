module Pjpp
  class QcCheckStatus < ActiveRecord::Base
    self.table_name = 'ja_qc_check_status'

    def return_status
      case self.check_status
        when nil
          'not checked'
        when false
          'checked faulty'
        when true
          'checked correct'
      end
    end
  end
end
