require 'json'
require "active_support/inflector"
class Predictor  < ActiveRecord::Base
  before_save :serialize_model
  serialize :selector_properties, JSON
  serialize :preprocessor_properties, JSON
  serialize :dictionary, JSON

  def model
    @model ||= Svm.load_from_string self.serialized_model
  end
  def preprocessor
    @preprocessor ||= self.used_preprocessor.constantize.new preprocessor_properties
  end
  def selector
    @selector ||= self.used_selector.constantize.new selector_params
  end

  def predict *args
    model.predict args
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