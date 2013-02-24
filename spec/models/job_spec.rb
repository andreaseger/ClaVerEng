require 'spec_helper'
require 'models/job.rb'

describe Job do
  subject(:job) {Job.find(1628207)} #this is a job which is correct

  context "classification_id" do
    %w(function career_level industry).each do |classification|
      it "should call #{classification}_id" do
        job.expects("#{classification}_id")
        job.classification_id(classification)
      end
    end
    context "act_as_false"do
      before(:each) do
        job.act_as_false!
      end
      it "should return a false function_id" do
        job.classification_id('function').should_not == 9
      end
      it "should return a false career_level_id" do
        job.classification_id('career_level').should_not == 4
      end
      it "should return a false industry_id" do
        job.classification_id('industry').should_not == 1100
      end
    end
  end
  context "label" do
    %w(function career_level industry).each do |classification|
      it "should return false if act_as_false" do
        job.act_as_false!
        job.label(classification).should be_false
      end
      it "should return true if not act_as_false" do
        job.label(classification).should be_true
      end
    end
  end
end