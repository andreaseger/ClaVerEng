require 'spec_helper'
require "preprocessors/simple.rb"

describe Preprocessor::Simple do
  let(:simple) { Preprocessor::Simple.new }
  it "should have process implemented" do
    expect { simple.process([]) }.to_not raise_error
  end
  context "cleanup title" do
    [ FactoryGirl.build(:job_title_w_gender),
      FactoryGirl.build(:job_title_w_gender_brackets),
      FactoryGirl.build(:job_title_w_gender_pipe),
      FactoryGirl.build(:job_title_w_gender_pipe_brackets),
      FactoryGirl.build(:job_title_w_gender2),
      FactoryGirl.build(:job_title_w_gender2_dash),
      FactoryGirl.build(:job_title_w_gender2_brackets),
      FactoryGirl.build(:job_title_w_code),
      FactoryGirl.build(:job_title_w_code2),
      FactoryGirl.build(:job_title_w_code3),
      FactoryGirl.build(:job_title_w_dash),
      FactoryGirl.build(:job_title_w_slash),
      FactoryGirl.build(:job_title_w_senior_brackets),
      FactoryGirl.build(:job_title_var_0),
      FactoryGirl.build(:job_title_w_special),
      FactoryGirl.build(:job_title_w_percent)].each do |job|
        it "should cleanup '#{job.title}'" do
          data = simple.process([job])
          data.each do |d|
            d.title.should eq(job.clean_title)
          end
        end
    end
  end
end