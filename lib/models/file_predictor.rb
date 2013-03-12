require 'json'
require "active_support/inflector"

class Model
  attr_accessor :id
  @@_attributes = Hash.new { |hash, key| hash[key] = [] }
  def self.attribute *attr
    attr.each do |name|
      define_method(name) do
        @_attributes[name]
      end
      define_method(:"#{name}=") do |v|
        @_attributes[name] = v
      end
      attributes << name unless attributes.include? name
    end
  end
  def serializable_hash
    attributes.inject({:id => @id}) do |a,key|
      a[key] = send(key)
      a
    end
  end
  def to_json
    serializable_hash.to_json
  end

  def save
    raise "Not yet implemented"
  end
  def self.load(params)
    new params
  end
  def initialize(params={})
    @_attributes = {}
    @_indizies = {}
    @id = nil
    params.each do |key, value|
      send("#{key}=", value)
    end
  end
  private
  def self.attributes
    @@_attributes[self]
  end
  def attributes
    self.class.attributes
  end
end

class Predictor < Model
  BASEDIR = File.expand_path(File.dirname(__FILE__) + '../../results')
  attribute :model_path,
            :classification,
            :preprocessor_class,
            :selector_class,
            :trainer_class,
            :dictionary,
            :selector_properties,
            :preprocessor_properties,
            :properties, # samplesize, dict_size, cost, gamma, kernel
            :metrics, # evaluator results
            :created_at
  attr_accessor :model,
                :preprocessor,
                :selector

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

  def created_at
    Time.mktime *super
  end
  def save
    prepare_model
    self.model_path, filename = filenames
    self.created_at = Time.now.to_a
    model.save(model_path)
    IO.save(filename, self.to_json)
  end

  def self.load_file(filename)
    load_json IO.read(filename)
  end
  def self.load_json(json)
    load JSON.parse(json)
  end
  def self.load(params)
    p = super
    p.model = Libsvm::Model.load(p.model_path)
    p.preprocessor = p.preprocessor_class.constantize.new(p.preprocessor_properties)
    p.selector = p.selector_class.constantize.new(p.selector_properties.merge( global_dictionary: p.dictionary, classification: p.classification))
    p
  end

  def initialize(params={})
    super
    self.preprocessor_properties ||= {}
    self.selector_properties ||= {}
    self.properties ||= {}
  end
  private
  def prepare_model
    self.id ||= next_id
    self.preprocessor_class ||= preprocessor.class.to_s
    self.selector_class ||= preprocessor.class.to_s
    self.dictionary ||= selector.global_dictionary
    self.preprocessor_properties.merge!(industry_map: preprocessor.industry_map ) if preprocessor.respond_to? :industry_map
    self.selector_properties.merge!(gram_size: selector.gram_size ) if selector.respond_to? :gram_size
    self.properties.merge!(dictionary_size: dictionary.size, cost: model.param.cost, gamma: model.param.gamma)
  end
  def filenames
    [ File.join(BASEDIR, "#{id}-model.libsvm"), File.join(BASEDIR, "#{id}-predictor.json") ]
  end
  def next_id
    #TODO
    345
  end
end
