require 'json'
require "active_support/inflector"
class Predictor  < ActiveRecord::Base
  before_save :serialize_model
  serialize :selector_properties, JSON
  serialize :preprocessor_properties, JSON
  serialize :dictionary, JSON

  def model
    @model ||= Model.load_from_string self.serialized_model
  end
  def preprocessor
    @preprocessor ||= self.used_preprocessor.constantize.new
  end
  def selector
    @selector ||= self.used_selector.constantize.new selector_params
  end

  def predict_job_id id
    predict_job Job.find(id)
  end
  def predict_job job
    data = preprocessor.process(job, classification)
    vector = selector.generate_vector(data, classification).data
    nodes = Node[vector.size].new
    vector.each.with_index{|e,i| nodes[i] = Node.new(i,e) }

    p "prediction: #{Svm.svm_predict model, nodes}"

    probs=Java::double[1].new
    p "prediction: #{Svm.svm_predict_probability model, nodes, probs} | probability: #{probs.first}"
  end

  def predict_meh job
    data = preprocessor.process(job, classification)
    vector = selector.generate_vector(data, classification)
    problem = Problem.from_array(vector.map(&:data), vector.map(&:label))
    p Svm.svm_predict model, problem.x[0]
  end

  def gamma
    model.gamma
  end
  def cost
    model.cost
  end

  def model=v
    @model = v
  end

  private
  def serialize_model
    self.serialized_model = model.serialize
  end
  def selector_params
    selector_properties.merge( global_dictionary: self.dictionary,
                               classification: self.classification )
  end
end