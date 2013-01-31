require 'spec_helper'
require 'runner'

describe Runner do
  subject(:runner) {Runner.new(dictionary_size: 100, max_samplesize: 100)}
  context "fetch_and_preprocess" do
    it "should preprocess the jobs" do
      runner.preprocessor.expects(:process)
      runner.fetch_and_preprocess(:function)
    end
    it "should return <samplesize> many objects" do
      r = runner.fetch_and_preprocess(:function)
      r.should have(100).things
    end
    it "should return many PreprocessedData Objects" do
      r = runner.fetch_and_preprocess(:function)
      r.each{|e| e.should be_a(PreprocessedData)}
    end
    it "should have a 50/50 distribution on true and false labels" do
      r = runner.fetch_and_preprocess(:function)
      r.group_by(&:label).each{|k,v| v.should have(50).items}
    end
  end
  context "fetch_test_set" do
    it "should generate feature vectors" do
      runner.stubs(:fetch_jobs)
      runner.preprocessor.stubs(:process)
      runner.selector.expects(:generate_vectors).returns([FeatureVector.new(data: [1,0,1], label: 0), FeatureVector.new(data: [1,0,0], label: 1)])
      runner.fetch_test_set(:function)
    end
    it "should return a libsvm problem", :slow do
      runner.fetch_test_set(:function).should be_a(Libsvm::Problem)
    end
    it "should return a libsvm problem with 2 features", :slow do
      runner.selector.stubs(:generate_vectors).returns([FeatureVector.new(data: [1,0,1], label: 0), FeatureVector.new(data: [1,0,0], label: 1)])
      runner.fetch_test_set(:function).l.should == 2
    end
  end
end