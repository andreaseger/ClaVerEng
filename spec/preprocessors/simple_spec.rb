require 'spec_helper'
require "preprocessors/simple"

describe Preprocessor::Simple do
  let(:simple) { Preprocessor::Simple.new }
  it "should have process implemented" do
    expect { simple.process([]) }.to_not raise_error
  end
  context "title" do
    [ FactoryGirl.build(:job_gender_in_title),
      FactoryGirl.build(:job_gender_in_title_alt) ].each do |job|
      it "should remove gender in title" do
        data = simple.process([job])
        data.each do |d|
          d.title.should eq("Some Job title")
        end
      end
    end
  end
end