require 'spec_helper'
require 'runner'
require 'models/predictor.rb'

describe Predictor do
  before(:all) do
    @runner = Runner.new(dictionary_size: 100, samplesize: 100)
    data = @runner.fetch_and_preprocess(:function)
    vectors = @runner.selector.generate_vectors(data, :function, 100)
    @model,_,@params = @runner.trainer.search(vectors,30)
  end
  subject(:predictor) { Predictor.new(model: @model, classification: :function,
                              preprocessor: @runner.preprocessor, selector: @runner.selector,
                              used_trainer: @runner.trainer.class.to_s, samplesize: 100 ) }
  %w(model preprocessor predict_job predict_job_id).each do |method|
    it { should respond_to(method) }
  end
  it "should serialize the model before save" do
    predictor.serialized_model.should be_nil
    predictor.save
    predictor.serialized_model.should_not be_nil
  end
  it "should update its settings before save" do
    settings = %w(used_preprocessor used_selector dictionary dictionary_size preprocessor_properties selector_properties)
    settings.each {|e| predictor.send(e).should be_nil}
    predictor.save
    settings.each {|e| predictor.send(e).should_not be_nil}
  end
  context "predict" do
    it "should return 0 or 1 as label" do
      label, _ = predictor.predict_job(Job.find(2343))
      [0,1].should include(label)
    end
    it "should return something between 0 and 1 as probability" do
      _, probability = predictor.predict_job(Job.find(2343))
      probability.should be_between(0,1)
    end
  end
end