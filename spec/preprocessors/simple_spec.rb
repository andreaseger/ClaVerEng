require 'spec_helper'
require "preprocessor/base"

describe Preprocessor::Simple do
  let(:simple) { Preprocessor::Simple.new }
  let(:job) { "TODO" }
  it "should cleanup the title" do
    data = simple.process([jobs])
    data.first[:title].should == "TODO some string without that wierd symbols and crap"
  end
end