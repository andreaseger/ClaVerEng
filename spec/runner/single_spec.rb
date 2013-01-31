require 'spec_helper'
require 'runner'

describe Runner do
  subject(:runner) {Runner.new(dictionary_size: 100, max_samplesize: 100)}

  context "run_for_classification", :slow do
    let(:data) { runner.fetch_and_preprocess(:function) }
    before(:all) do
      @vectors = runner.selector.generate_vectors(data, :function, 100)
      @model_and_foo = runner.trainer.search(@vectors,30)
    end
    it "should call generate_vectors on selector" do
      runner.selector.expects(:generate_vectors).at_least_once.returns(@vectors)
      runner.run_for_classification(data, :function)
    end
    it "should call a trainer" do
      runner.trainer.expects(:search).with(@vectors,30).returns(@model_and_foo)
      runner.run_for_classification(data, :function)
    end
    it "should return a Predictor" do
      runner.trainer.stubs(:search).returns(@model_and_foo)
      runner.run_for_classification(data,:function).should be_a(Predictor)
    end
    it "should not raise any errors" do
      ->{ runner.run_for_classification(data,:function) }.should_not raise_error
    end
  end

  context "setup" do
    it "should load the correct Preprocessor" do
      runner.preprocessor.should be_a(Preprocessor::Simple)
    end
    it "should load the correct Selector" do
      runner.selector.should be_a(Selector::Simple)
    end
    it "should load the correct Trainer" do
      runner.trainer.should be_a(SvmTrainer::GridSearch)
    end
    context "trainers" do
      it "should use the linear search trainer" do
        Runner.new(trainer: :linear).trainer.should be_a(SvmTrainer::Linear)
      end
      it "should use the grid search trainer" do
        Runner.new(trainer: :grid).trainer.should be_a(SvmTrainer::GridSearch)
      end
      it "should use the doe heuristic trainer" do
        Runner.new(trainer: :doe).trainer.should be_a(SvmTrainer::DoeHeuristic)
      end
      it "should use the nelder mead trainer" do
        Runner.new(trainer: :nelder_mead).trainer.should be_a(SvmTrainer::NelderMead)
      end
    end
    context "selectors" do
      it "should use the simple selector" do
        Runner.new(selector: :simple).selector.should be_a(Selector::Simple)
      end
      it "should use the n-gram selector" do
        Runner.new(selector: :ngram).selector.should be_a(Selector::NGram)
      end
    end
  end
end