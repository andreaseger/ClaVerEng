require 'spec_helper'
require_relative '../config/environment'
require 'runner'

describe Runner do
  subject(:runner) {Runner.new}
  context "fetch_and_preprocess" do
    
  end
  context "run_for_classification" do
    
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