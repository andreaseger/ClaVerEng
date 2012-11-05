module Pjpp
  class JobStatus < ActiveRecord::Base
    self.table_name = 'job_status'
    has_many :jobs, class_name: 'Pjpp::Job', foreign_key: 'job_status_id'
  
    module JobExtension
      def method_missing(method_name, *arguments)
        case method_name.to_s[-1,1]
        when "!"
          name=method_name.to_s[0..-2]
          status= JobStatus.by_name(name) 
          if status
            proxy_owner.status = status
          else
            super
          end
        when "?"
          name=method_name.to_s[0..-2]
          if JobStatus.by_name(name)
            proxy_target.name == name
          else
            super
          end
        else
          super
        end
      end
    end
    include JobExtension
  
    private
    #to let the JobExtension do it's magic
    def proxy_target
      self
    end
  end
end
