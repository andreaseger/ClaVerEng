module Trainer
  module Helper
    def build_parameter *args
      cost, gamma = if args.size == 2
                      args
                    else
                      [args[:cost], args[:gamma]]
                    end
      Parameter.new(:svm_type => Parameter::C_SVC,
                    :kernel_type => Parameter::RBF,
                    :cost => cost,
                    :gamma => gamma)
    end
  end
end