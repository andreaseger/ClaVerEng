require 'json'
require "active_support/inflector"
#
# Saves information about a SVM
#
# @author Andreas Eger
#
class Predictor  < ActiveRecord::Base
  before_save :serialize_model, :update_settings
  serialize :selector_properties, JSON
  serialize :preprocessor_properties, JSON
  serialize :dictionary, JSON
  attr_writer :model, :preprocessor, :selector

  def initialize(args)
    @preprocessor = args.fetch(:preprocessor)
    @selector = args.fetch(:selector)
    params = args.tap{|h| h.delete(:preprocessor); h.delete(:selector)}
    super(params)
  end
  def model
    @model ||= Libsvm::Model.parse self.serialized_model
  end
  def preprocessor
    @preprocessor ||= self.used_preprocessor.constantize.new preprocessor_properties
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
    features = Libsvm::Node.features(selector.generate_vector(data, classification).data)

    label, probs = model.predict_probability(features)
    # TODO find a more reliable way to find the correct probability value for the given label
    # but nevertheless this should be correct
    return label, probs.max
  end

  def gamma
    model.param.gamma
  end

  def cost
    model.param.c
  end

  # TODO make a method which describes the different classes
  # i.e. first_class => true, second_class => false
  # problem this order seems to depend on the first example/problem/node used for training

  def test_model test_set, verbose=false
    self.tap do |p|
      p.overall_accuracy = SvmTrainer::Evaluator::OverallAccuracy.new(p.model, verbose).evaluate_dataset(test_set)
      p.geometric_mean = SvmTrainer::Evaluator::GeometricMean.new(p.model, verbose).evaluate_dataset(test_set)
    end
  end

  private
  def serialize_model
    self.serialized_model = model.serialize
  end
  def update_settings
    self.used_preprocessor ||= preprocessor.class.to_s
    self.used_selector ||= selector.class.to_s
    self.preprocessor_properties ||= {}
    self.selector_properties ||= {}
    self.preprocessor_properties.merge!(industry_map: preprocessor.industry_map )
    self.selector_properties.merge!(gram_size: selector.gram_size ) if selector.respond_to? :gram_size
    self.dictionary = selector.global_dictionary.map { |e| e.force_encoding("UTF-8") }
    self.dictionary_size = dictionary.size
  end
  def selector_params
    selector_properties.merge( global_dictionary: self.dictionary,
                               classification: self.classification )
  end
end