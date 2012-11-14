require 'spec_helper'

shared_examples_for 'a preprocessor' do
  let(:preprocessor) { described_class.new }
  let(:job) { FactoryGirl.build(:dummy_job) }
  let(:jobs) { [job] }

  it { preprocessor.should respond_to :process }
  it "should return a list of object with a data attribute" do
    preprocessor.process(job).should respond_to :data
  end
  it "should return a list of object with a label attribute" do
    preprocessor.process(job).should respond_to :label
  end
  it "should be able to process multiple jobs" do
    preprocessor.process(jobs).each do |e|
      e.should respond_to :data
      e.should respond_to :label
    end
  end
end
