module Trainer
  module Helper
    def build_parameter args
      cost = args[:cost]
      gamma = args[:gamma]
      kernel =  case args[:kernel]
                when :linear
                  Parameter::LINEAR
                when :rbf
                  Parameter::RBF
                else
                  Parameter::RBF
                end

      Parameter.new(svm_type: Parameter::C_SVC,
                    kernel_type: kernel,
                    cost: cost,
                    gamma: gamma,
                    probability: 1)
    end
  end
end