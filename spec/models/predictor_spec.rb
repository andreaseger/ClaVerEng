require 'spec_helper'
require 'runner/single'
require 'models/predictor.rb'

describe Predictor do
  before(:all) do
    runner = Runner::Single.new(verbose: false)
    Predictor.any_instance.stubs(:save)
    @predictor = runner.run(:simple, :simple, :linear, {classification: :function, max_samplesize: 100, dictionary_size: 100} )
  end
  #before(:each) { @predictor.stubs(:save) }
  #this will basically produce crap but thats not important
  subject(:predictor) { @predictor }
  %w(model preprocessor predict_job predict_job_id).each do |method|
    it { should respond_to(method) }
  end
  it "should update its settings before save" do
    settings = %w(serialized_model used_preprocessor used_selector dictionary dictionary_size preprocessor_properties selector_properties)
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