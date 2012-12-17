require 'json'
require "active_support/inflector"
#
# Saves information about a SVM
#
# @author Andreas Eger
#
class Predictor  < ActiveRecord::Base
  before_save :serialize_model
  serialize :selector_properties, JSON
  serialize :preprocessor_properties, JSON
  serialize :dictionary, JSON
  attr_writer :model

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

  #
  # predict the label w/ probability of a given job
  # @param  job [Job]
  #
  # @return [Integer,Double] label as Integer and the probability of this label
  def predict_job job
    data = preprocessor.process(job, classification)
    vector = selector.generate_vector(data, classification).data
    nodes = make_nodes(vector)

    label, probs = model.predict_probability(nodes)
    # TODO find a more reliable way to find the correct probability value for the given label
    # but nevertheless this should be correct
    return label, probs.max
  end

  def gamma
    model.gamma
  end

  def cost
    model.cost
  end

  # TODO make a method which describes the different classes
  # i.e. first_class => true, second_class => false
  # problem this order seems to depend on the first example/problem/node used for training

  private
  def serialize_model
    self.serialized_model = model.serialize
  end
  def selector_params
    selector_properties.merge( global_dictionary: self.dictionary,
                               classification: self.classification )
  end
  def make_nodes vector
    nodes = Node[vector.size].new
    vector.each.with_index{|e,i| nodes[i] = Node.new(i,e) }
    nodes
  end
end